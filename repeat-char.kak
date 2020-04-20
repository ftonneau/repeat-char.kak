# Insert a chosen character n times.
# Author: Francois Tonneau

define-command \
-docstring \
'repeat-char-enable-on <key>: allow character repetition with <key>' \
-params 1 \
repeat-char-enable-on %{
    try %{
        remove-hooks global repeat-char
    }
    hook -group repeat-char global InsertKey %arg(1) repeat-char-insert
}

define-command \
-docstring \
'Disable character-repetition command' \
repeat-char-disable %{
    remove-hooks global repeat-char
}

define-command \
-hidden \
repeat-char-insert %{
    prompt 'enter <count><char> (e.g., 10*):' %{
        evaluate-commands %sh{
            rule=$kak_text
            length=$(expr length "$rule")
            digit_and_char=2
            if [ $length -lt $digit_and_char ]; then
                printf %s\\n 'fail missing digits or character'
                exit
            fi
            count=$(expr substr "$rule" 1 $((length-1)))
            char=$(expr substr  "$rule" $length 1)
            if ! expr "$count" : '[1-9][0-9]*$' >/dev/null; then
                printf %s\\n 'fail incorrect format'
                exit
            fi
            #
            seq=
            step=0
            while [ $step -lt $count ]; do
                seq=${seq}${char}
                step=$((step + 1))
            done
            if [ "$char" = "'" ]; then
                seq='"'${seq}'"'
            else
                seq="'"${seq}"'"
            fi
            #
            # '--': avoid interpreting a sequence of - as a command option.
            printf %s\\n "execute-keys -- $seq"
        }
    }
}

