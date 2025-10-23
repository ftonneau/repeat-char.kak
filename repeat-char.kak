# This script inserts a chosen character n times.
# Author: François Tonneau

declare-option -docstring 'default count for repeat-char' \
int repeat_char_n 60

declare-option -docstring 'default character for repeat-char' \
str repeat_char_ch '-'

define-command -docstring \
'repeat-char-enable-on <key>: enable character repetition with <key>' \
-params 1 repeat-char-enable-on %{
    try %{
        remove-hooks global repeat-char
    }
    hook -group repeat-char global InsertKey %arg(1) repeat-char-proceed
}

define-command -docstring \
'repeat-char-disable: disable character-repetition command' \
repeat-char-disable %{
    remove-hooks global repeat-char
}

# ------------------------------------------------------------
# Implementation
# ------------------------------------------------------------

declare-option -hidden int repeat_char_limit

define-command -hidden repeat-char-proceed %{
    prompt 'enter <count><char> (e.g., 10*) OR <char><char>:' %{
        evaluate-commands -save-regs dquote %sh{
            printf %s\\n "$kak_text" | \
            awk \
            -v defcount="$kak_opt_repeat_char_n" \
            -v defchar="$kak_opt_repeat_char_ch" '
                function wants_trace(code) {
                    return code ~ /^[^[:digit:]][^[:digit:]]$/ && \
                    substr(input, 1, 1) == substr(input, 2, 1)
                }

                function quoted(character) {
                    Open = "%{"
                    Close = "}"
                    Quote = "\047" 
                    if (char == Quote) return Open char Close
                    else return Quote char Quote
                }

                {
                    input=$0
                    OFS = " "
                    # Deal with special case first, and exit.
                    if (wants_trace(input)) {
                        char = substr(input, 1, 1)
                        print("repeat-char-trace", quoted(char))
                        exit
                    }
                    # Then deal with regular count-char repetition. 
                    if (input == "") {
                        count = defcount
                        char = defchar
                    }
                    else if (input ~ /^[[:digit:]]+$/) {
                        count = input + 0
                        char = defchar
                    }
                    else if (input ~ /^[^[:digit:]]$/) {
                        count = defcount
                        char = input
                    }
                    else if (input ~ /^[[:digit:]]+[^[:digit:]]$/) {
                        char = substr(input, length(input))
                        sub(/.$/, "", input)
                        count = input + 0
                    }
                    else exit
                    print("set buffer repeat_char_n " count)
                    print("set buffer repeat_char_ch " quoted(char))
                    print("repeat-char-repeat", count, quoted(char))
                }
            '
        }
    }
}

define-command -hidden -params 2 repeat-char-repeat %{
    evaluate-commands %sh{
        awk \
        -v count="$1" \
        -v char="$2" '
            BEGIN {
                Open = "%{"
                Close = "}"
                Quote = "\047" 
                for (k = 1; k <= count; k++) seq = seq char
                if (char == Quote) argument = Open seq Close
                else argument = Quote seq Quote
                print("execute-keys -with-hooks -- " argument)
            }
        '
    }
}

define-command -params 1 repeat-char-trace %{
    try %{
        evaluate-commands -draft %{
            execute-keys k x
            execute-keys 1 s (\S) \s* \n
            execute-keys l 
            set-option buffer repeat_char_limit %val(cursor_display_column)
        }
        evaluate-commands -draft %{
            execute-keys <semicolon>
            set-option -remove buffer repeat_char_limit %val(cursor_display_column)
        }
        repeat-char-repeat %opt(repeat_char_limit) %arg(1)
    }
}

