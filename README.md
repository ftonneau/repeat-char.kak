# repeat-char.kak

This plugin for [Kakoune](https://kakoune.org/) allows you to insert a non-numeric
character `c` a number of times in Insert mode.

Character repetition can be done by **counting**: the chosen character is repeated
exacty _n_ times, as in this example:

```
------------------------------------------------------------
A new section start here.
...
```

where the hyphen (`-`) is repeated 60 times.

Alternatively, character repetition can be done by **tracing**: the character is
repeated until it coincides with the end of a heading on the preceding line. Thus,
in this example:

```
Heading level 1
===============
```

the last equal sign (`=`) is aligned with `1`.


# Repetition by counting

Repetition by counting starts by pressing a **hotkey**. The results will depend on two
parameters:

* the **default character**: i.e., the defaut value of `c`

* the **default count**: i.e., the default value of _n_.

Assume for example that the hotkey is `<a-r>`. Then, whenever you'll type `<a-r>` in
Insert Mode, the plugin will prompt you to enter a positive integer (`n`) followed by
a non-numeric character (`c`). There should be no space between the integer and the
character, and both can be omitted:

* If you omit everything (i.e., if you just press ENTER at the prompt), the
default character will be inserted default-count times.

* If you specify `n` and omit the character, the default character will be
inserted _n_ times, and _n_ **will become the new default count**.

* If you omit the integer and specify `c`, `c` will be inserted default-count
times, and `c` **will become the new default character**.

* If you specify both an integer `n` and a character `c`, `c` will be inserted
_n_ times, _n_ will become the new default count, and `c` will become the new
default character.


# Example 

If the default character is `-` and the defaut count is 60, then pressing ENTER after
the hotkey will insert:

```
------------------------------------------------------------
```

automatically. If at some point you decide to shorten the ruler to a length of 10,
then typing `10` and pressing ENTER after the hotkey will insert:

```
----------
```

and this shorter ruler will become the new default. Finally, to replace the 10
hyphens by 10 asterisks, type `*` and ENTER after the hotkey:

```
**********
```


# Repetition by tracing

Repetition by tracing starts by pressing the hotkey. After pressing the hotkey, however,
the plugin prompts you to enter the **same non-numeric character twice**. The plugin
then repeats this character so as to "underline" the preceding heading.

Notice that repetition by tracing and repetition by counting proceed independently of
one another. In particular, repetition by tracing **leaves the default count and the
default character unaffected**.


# Example 

Assume your cursor is positioned at the start of the line after:

```
Heading level 1

```

Pressing `<a-r>`, then `==` followed by ENTER will produce:

```
Heading level 1
===============
```


# Installation

Download the provided [repeat-char.kak](./repeat-char.kak) file and copy it
somewhere in your `autoload` directory tree.


# Enabling and disabling character repetition

Before being used, the **plugin must be enabled** with the `repeat-char-enable-on
<key>` command, which you may want to add to your `kakrc` (replacing `<key>` by the
hotkey of your choice, for example, `<a-r>`).

Character repetition can be disabled at any time with the `repeat-char-disable`
command.


# Customization

Aside from the value of the hotkey (customized via `repeat-char-enable-on`), you can
customize **the initial value of the default character** via the `repeat_char_ch`
option, and the **initial value of the default count** via the `repeat_char_n`
option. Out of the box, these equal `-` and 60, respectively.

