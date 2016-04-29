# Command line prompt

Besides the sam command language the following commands are also recognized
at the `:`-command prompt. Any unique prefix can be used.

    :bdelete      close all windows which display the same file as the current one
    :earlier      revert to older text state
    :e            replace current file with a new one or reload it from disk
    :langmap      set key equivalents for layout specific key mappings
    :later        revert to newer text state
    :!            launch external command, redirect keyboard input to it
    :map          add a global key mapping
    :map-window   add a window local key mapping
    :new          open an empty window, arrange horizontally
    :open         open a new window
    :qall         close all windows, exit editor
    :q            close currently focused window
    :r            insert content of another file at current cursor position
    :set          set the options below
    :split        split window horizontally
    :s            search and replace currently implemented in terms of `sed(1)`
    :unmap        remove a global key mapping
    :unmap-window remove a window local key mapping
    :vnew         open an empty window, arrange vertically
    :vsplit       split window vertically
    :wq           write changes then close window
    :w            write current buffer content to file

For details on the `:map*` commands, see [mapping](mapping.md.html).

## Set

The set command changes a number of options relating to the display and
behaviour of the editor. The available options are listed below with the
possible values for that option and the default.

    tabwidth   [1-8]           default 8

      set display width of a tab and number of spaces to use if
      expandtab is enabled

    expandtab  (yes|no)        default no

      whether typed in tabs should be expanded to tabwidth spaces

    autoindent (yes|no)        default no

      replicate spaces and tabs at the beginning of the line when
      starting a new line.

    number         (yes|no)    default no
    relativenumber (yes|no)    default no

      whether absolute or relative line numbers are printed alongside
      the file content

    syntax      name           default yes

      use syntax definition given (e.g. "c") or disable syntax
      highlighting if no such definition exists (e.g :set syntax off)

    show

      show/hide special white space replacement symbols

      newlines = [0|1]         default 0
      tabs     = [0|1]         default 0
      spaces   = [0|1]         default 0

    cursorline (yes|no)        default no

      highlight the line on which the cursor currently resides

    colorcolumn number         default 0

      highlight the given column

    horizon    number          default 32768 (32K)

      how far back the lexer will look to synchronize parsing

    theme      name            default dark-16.lua | solarized.lua (16 | 256 color)

      use the given theme / color scheme for syntax highlighting

Commands taking a file name will use a simple file open dialog based on the
`vis-open` shell script and the [`slmenu`](https://bitbucket.org/rafaelgg/slmenu)
utility, if given a file pattern or directory.

    :e *.c          # opens a menu with all C files
    :e .            # opens a menu with all files of the current directory
