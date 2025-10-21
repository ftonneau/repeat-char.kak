# Insert a chosen character n times.
# Author: François Tonneau

declare-option -docstring 'default character for repeat-char' \
str repeat_char_ch '-'

declare-option -docstring 'default count for repeat-char' \
int repeat_char_n 60

define-command -docstring \
'repeat-char-enable-on <key>: enable character repetition with <key>' \
-params 1 repeat-char-enable-on %{
    try %{
        remove-hooks global repeat-char
    }
    hook -group repeat-char global InsertKey %arg(1) repeat-char-insert
}

define-command -docstring \
'repeat-char-disable: disable character-repetition command' \
repeat-char-disable %{
    remove-hooks global repeat-char
}

define-command -hidden repeat-char-insert %{
    prompt 'enter <count><char> (e.g., 10*):' %{
        evaluate-commands -save-regs dquote %sh{
            printf %s\\n "$kak_text" | \
            awk \
            -v "defchar=$kak_opt_repeat_char_ch" \
            -v "defcount=$kak_opt_repeat_char_n" ' {
                input=$0
                sub(/^0+/, "", input)

                # Read value(s) from input.
                if (input == "") {
                    char = defchar
                    count = defcount
                }
                else if (input ~ /^[[:digit:]]+$/) {
                    char = defchar
                    count = input + 0
                }
                else if (input ~ /^[^[:digit:]]$/) {
                    char = input
                    count = defcount
                }
                else if (input ~ /^[[:digit:]]+[^[:digit:]]$/) {
                    char = substr(input, length(input))
                    sub(/.$/, "", input)
                    count = input + 0
                }
                else exit

                # Adjust defaults with values.
                Open = "%{"
                Close = "}"
                Quote = "\047" 
                if (char == Quote) print("set global repeat_char_ch " Open char Close)
                else print("set global repeat_char_ch " Quote char Quote)
                print("set global repeat_char_n " count)

                # Make Kakoune type the chosen character sequence.
                for (k = 1; k <= count; k++) seq = seq char
                if (char == Quote) argument = Open seq Close
                else argument = Quote seq Quote
                print("execute-keys -with-hooks -- " argument)
            } '
        }
    }
}

