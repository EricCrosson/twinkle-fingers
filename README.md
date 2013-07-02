# Twinkle Fingers mode

This is a mode to provide a simple way to write emacs lisp
code. Specifically, one can write proper emacs lisp without knowledge
of the commands that keybindings run- with `twinkle-fingers` enabled,
pressing a command's keybinding will insert the name of that command
as a function call at point.

Caveat: the user will still be responsible for supplying any arguments
necessary for commands. As such, there is an insert period whereby one
is free to add any arguments before pressing <kbd>return</kbd> to
signal `twinkle-fingers` that one is ready to enter the next command.

### Recommended adjucnt modes

I wouldn't dream of this mode if it weren't for Eldoc mdoe.

## Non-standard behavior

As we all know, pressing a letter key calls the `self-insert-command`,
which isn't all too useful on its own. As such, if a user presses a
key correlating to `self-insert-command` inside of `twinkle-fingers`,
the command entered at point will be `(insert "|")`, which will allow
him or her to enter any number of characters desired.
