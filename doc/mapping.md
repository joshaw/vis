# Runtime Configurable Key Bindings

Vis supports run time key bindings via the `:{un,}map{,-window}` set of
commands. The basic syntax is:

    :map[!] <mode> <lhs> <rhs>

where 

- `mode` is one of `normal`, `insert`, `replace`, `visual`, `visual-line` or 
  `operator-pending` 
- `lhs` refers to the key to map
- `rhs` is a key action or alias
- an existing mapping can be overridden by appending `!` to the map command.

Key mappings are always recursive, this means doing something like:

    :map! normal j 2j

will not work because it will enter an endless loop. Instead vis uses
pseudo keys referred to as key actions which can be used to invoke a set
of available (see :help or `<F1>` for a list) editor functions. Hence
the correct thing to do would be:

    :map! normal j 2<cursor-line-down>

Unmapping works as follows:

    :unmap <mode> <lhs>

The commands suffixed with `-window` only affect the currently active window.

Mapping can also be acheived using the [lua api](lua_api.md.html).

## Layout Specific Key Bindings

Vis allows setting key equivalents for non-latin keyboard layouts. This
facilitates editing non-latin texts. The defined mappings take effect
in all non-input modes, i.e. everywhere except in insert and replace mode.

For example, the following maps the movement keys in Russian layout:

    :langmap ролд hjkl

More generally the syntax of the `:langmap` command is:

    :langmap <sequence of keys in your layout> <sequence of equivalent keys in latin layout>

If the key sequences do not have the same length, the rest of the longer
sequence will be discarded.
