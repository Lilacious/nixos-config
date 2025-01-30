{
  opts = {
    ## Line
    number = true; # Show (current*[if relativenumber==true]) line number
    relativenumber = false; # Show the relative line number to the cursor
    wrap = true; # Lines longer than the width of the window will wrap
    cursorline = true; # Highlight the text line of the cursor
    ## Tabs & indentation
    tabstop = 2; # Set tab == n spaces
    shiftwidth = 2; # Set indent with to n spaces
    expandtab = false; # Expand tab into spaces
    autoindent = true; # Copy current indent to new line
    ## Search
    ignorecase = true; # Ignore case while searching
    smartcase = true; # Turn on case sensitivity automatically when needed
    hlsearch = true; # Highlight all search matches
    ## Split windows
    splitright = true; # Split vertical window to the right
    splitbelow = true; # Split horizontal window to the bottom
    ## Other
    signcolumn = "yes"; # Show sign column so the text doesn't shift
    backspace = "indent,eol,start"; # Allow backspace on specified positions
    scrolloff = 3; # Number of lines to keep above and below cursor

    ## GOATED
    undofile = true; # Persistent undo history
    inccommand = "nosplit"; # Live preview for substitute (:s/<old>/<new>)
  };
}
