# repeat-char.kak

This plugin for [Kakoune](https://kakoune.org/) allows you to insert a non-numeric
character `c` exactly _n_ times in Insert mode.

# Usage

How the plugin works depends on three parameters:

* the **hotkey**: i.e., the key combination that launches character insertion

* the **default character**: i.e., the defaut value of `c`

* the **default count**: i.e., the default value of _n_.

Assume for example that the hotkey is `<a-r>`. Then, whenever you'll type `<a-r>` in
Insert Mode, the plugin will prompt you to enter a positive integer (_n_) followed by
a non-numeric character (`c`). There should be no space between the integer and the
character, and both can be omitted:

* if you omit everything (i.e., if you just press ENTER at the prompt), then the
default character will be inserted default-count times.

* if you specify `n` and omit the character, then the default character will be
inserted _n_ times, and _n_ **will become the new default count**.

* if you omit the integer and specify `c`, then `c` will be inserted default-count
times, and `c` **will become the new default character**.

* if you specify both an integer `n` and a character `c`, then `c` will be inserted
_n_ times; also, _n_ will become the new default count, and `c` will become the new
default character.


# Example: rulers

The plugin makes it easy to insert ASCII rulers to start a new section of text. If,
for example, the default character is `-` and the defaut count is 60, then pressing
ENTER after the hotkey will insert:

------------------------------------------------------------

automatically. If at some point you decide to shorten the ruler to a length
of 10, then typing `10` and pressing ENTER after the hotkey will insert:

----------

and this shorter ruler will become the new default.


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

Aside from the value of the hotkey (customized via `repeat-char-enable`), you can
customize the initial value of the default character via the `repeat_char_ch` option,
and the initial value of the default count via the `repeat_char_n` option. Out of the
box, these equal `-` and 60, respectively.

