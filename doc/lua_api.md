Lua API for in process extension
================================

Vis provides a simple Lua API for in process extension. At startup the
`visrc.lua` file is executed, this can be used to register a few event
callbacks which will be invoked from the editor core. While executing
these user scripts the editor core is blocked, hence it is intended for
simple short lived (configuration) tasks.

At this time there exists no API stability guarantees.

## `vis`

- `vis.events`
    - Functions that are run following specific events during vis execution
    - `vis.events.start()`
        - Once at startup after the ui is initialised
    - `vis.events.theme_change(name)`
        - After the theme is set with `set theme x`
        - The name of the new theme is passed as the argument
    - `vis.events.quit()`
        - Once before exiting
    - `vis.events.win_close(win)`
        - Every time a window is closed
        - The window is passed as the argument
    - `vis.events.win_highlight(win)`
        - TODO
    - `vis.events.win_open(win)`
        - Every time a new window is created
        - The window is passed as the argument
    - `vis.events.win_status(win)`
        - Called when the statusline for a window needs to be updated
        - Use with `win.status(text)` function
        - Default implementation, contained in system `vis.lua` file can be 
          overwritten
    - `vis.events.win_syntax(win, name)`
        - Called when the syntax definition of a window is set or changed
        - Default in `vis.lua` should not need to be changed in most cases
        - Should set the syntax of the window to `name`
    - Example
      ```lua
      vis.events.win_open = function(win)
          vis:info('File name of new window is ' .. win.file.name)
      end
      ```
- `vis.lexers`
    - LPeg lexer support module
- `vis.mode`
    - Current mode, one of the below constants
- `vis.MODE_NORMAL`
- `vis.MODE_OPERATOR_PENDING`
- `vis.MODE_INSERT`
- `vis.MODE_REPLACE`
- `vis.MODE_VISUAL`
- `vis.MODE_VISUAL_LINE`
    - Mode constants
- `vis.recording`
    - True, if a macro is currently being recorded
    - Useful for displaying in the statusline
- `vis.VERSION`
    - Version information string in `git describe` format
    - Same as reported by `$ vis -v`
- `vis.win`
    - `window` object representing the currently focused window
- `vis:command(cmd)`
    - Run the vis command as if it had been typed at the command (`:`) prompt
    - Example: `vis:command('set number')`
- `vis:command_register(name, function(argv, force, win, cursor, range))`
    - Hook up a Lua function to `:name` command
    - `argv`: arguments passed to the function
    - `force`: true if the function was invoked with `!`
    - `win`: the current `window`, where the command was run from
    - `cursor`: the current set of `cursor`s active
    - `range`: the range that was used when running the command as byte offsets 
      from the start of the file
    - Example
      ```lua
      vis:command_register("foo", function(argv, force, win, cursor, range)
          for i,arg in ipairs(argv) do
              print(i..": "..arg)
          end
          print("was command forced with ! "..(force and "yes" or "no"))
          print(win.file.name)
          print(cursor.pos)
          print(range ~= nil and ('['..range.start..', '..range.finish..']') or "invalid range")
          return true;
      end)
      ```
    
- `vis:feedkeys(keys)`
    - Interpret `keys` as if they were read from the keyboard.
    - If called from a key handling function, the keys will only be processed 
      *after* the current key handling function has returned
- `vis:files()`
    - Iterator over all files currently open
- `vis:info(msg)`
    - Display a single line message
    - Example `vis:info('A message from vis')`
- `vis:map(mode, key, function)`
    - Map a Lua function to `key` in `mode`
    - `mode`: the mode that the key mapping will apply in
    - `key`: key to map to
    - `function`: function to execute when key `key` is pressed
    - Example
      ```lua
      vis:map(vis.MODE_NORMAL, "Q", function(
          vis:info('You pressed Q')
          end
      )
      ```
- `vis:message(msg)`
    - Display an arbitrarily long message
- `vis:motion(id)`
    - Select/execute a motion
    - `id`: the identifier returned by `vis:motion_register()`
- `vis:motion_register(function)`
    - Register a Lua function as a motion
    - Returns associated `id` or `-1`
- `vis:open(filename)`
    - Open the file `filename` in a new split window
- `vis:textobject(id)`
    - Select/execute a text object
    - `id`: the identifier returned by `vis:textobject_register()`
- `vis:textobject_register(function)`
    - Register a Lua function as a text object
    - Returns associated `id` or `-1`
- `vis:windows()`
    - Iterator over all windows currently visible

### `file`
- `file.name`
    - Name of the file
- `file.lines[1..#lines]`
    - Array giving read and write access to lines in the file
- `file.modified`
    - True if the file has unsaved changes
- `file.newlines`
    - Type of newlines, either `"nl"` or `"crnl"`
- `file.size`
    - Current file size in bytes
- `file:content(pos, len)`
    - Returns `len` bytes of the file starting at byte number `pos` 
    - As a single string
- `file:content({start, finish})`
    - Returns a string containing the contents of the file 
    - From byte `start` until byte `finish`.
- `file:delete(pos, len)`
    - Remove `len` bytes from the contents of the file starting at byte position 
      `pos`
- `file:delete({start, finish})`
    - Remove content from the file starting at byte `start` until byte `finish`
- `file:insert(pos, data)`
    - Insert the given `data` into the file at byte position `pos`
- `file:lines_iterator()`
    - Iterator over all lines in the file

### `window`
- `window.cursor`
    - `cursor` object representing the primary cursor
- `window.cursors[1..#cursors]`
    - Array giving read and write access to all cursors
- `window.height`
    - Y-dimension of the given window in character cells
    - See also `window.width`
- `window.file`
    - `file` object representing the file displayed in the window
- `window.syntax`
    - Lexer name used for syntax highlighting or `nil`
- `window.viewport`
    - Range denoting the currently visible area of the window
- `window.width`
    - X-dimension of the given window in character cells
    - See also `window.height`
- `window:cursors_iterator()`
    - Iterator over all cursors
- `window:status(text)`
    - Set the content of the window status bar
    - Used from `vis.events.win_status(win)` event
- `window:style_define(id, style)`
    - Define a new style for use with `window:style()`
    - `id`: constant to set as the reference for the new style
    - `style`: string giving the name of the new style
- `window:style(id, start, end)`
    - Apply the style with id `id` to the given file range
    - `id`: identifier of the style, as given by `win:syle_define()`
    - `start`, `end`: where to apply the style

### `cursor`
- `cursor.col` (1 based)
    - Column number of the cursor
- `cursor.line` (1 based)
    - Line number of the cursor
- `cursor.number`
    - index of cursor (1 based)
- `cursor.pos`
    - Bytes from start of file (0 based)
- `cursor.selection`
    - Read/write access to selection represented as a `range` object
- `cursor:to(line, col)`
    - Move the cursor to line number `line` and column `col`

### `range`
- Denoted by absolute positions in bytes from the start of the file
- An invalid range is represented as `nil`
- `range.start`
- `range.finish`

Most of the exposed objects are managed by the C core. Although there
is a simple object life time management mechanism in place, it is still
recommended to *not* let the Lua objects escape from the event handlers
(e.g. by assigning to global Lua variables).