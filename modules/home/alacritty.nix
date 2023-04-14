{ config, pkgs, lib, ... }:
let
  normalFontFamily        =       "Fira Code";
  boldFontFamily          =       "Fira Code";
  italicFontFamily        =       "Fira Code";
  boldItalicFontFamily    =       "Fira Code";

in
{
  programs.alacritty = {
    enable = true;

    settings = {

      # TERM variable
      #
      # This value is used to set the `$TERM` environment variable for
      # each instance of Alacritty. If it is not present, alacritty will
      # check the local terminfo database and use `alacritty` if it is
      # available, otherwise `xterm-256color` is used.
      
      env.TERM = "xterm-256color";

      window = {

        # Window dimensions (changes require restart)
        #
        # Number of lines/columns (not pixels) in the terminal. Both lines and columns
        # must be non-zero for this to take effect. The number of columns must be at
        # least `2`, while using a value of `0` for columns and lines will fall back
        # to the window manager's recommended size.
        
        dimensions = {
          columns = 0;
          lines = 0;
        };

        # Window position (changes require restart)
        #
        # Specified in number of pixels.
        # If the position is not set, the window manager will handle the placement.

        #position = {
        #  x = 0;
        #  y = 0;
        #};

        # Window padding (changes require restart)
        #
        # Blank space added around the window in pixels. This padding is scaled
        # by DPI and the specified value is always added at both opposing sides.
        
        padding = {
          x = 5;
          y = 5;
        };
        
        # Spread additional padding evenly around the terminal content.
        
        dynamic_padding = false;

        # Window decorations
        #
        # Values for `decorations`:
        #     - full: Borders and title bar
        #     - none: Neither borders nor title bar
        #
        # Values for `decorations` (macOS only):
        #     - transparent: Title bar, transparent background and title bar buttons
        #     - buttonless: Title bar, transparent background and no title bar buttons
        
        decorations = "full";

        # Background opacity
        #
        # Window opacity as a floating point number from `0.0` to `1.0`.
        # The value `0.0` is completely transparent and `1.0` is opaque.
        
        opacity= 1.0;

        # Startup Mode (changes require restart)
        #
        # Values for `startup_mode`:
        #   - Windowed
        #   - Maximized
        #   - Fullscreen
        #
        # Values for `startup_mode` (macOS only):
        #   - SimpleFullscreen
        
        startup_mode = "Windowed";

        # Window title

        title = "Alacritty";

        # Allow terminal applications to change Alacritty's window title.
        
        dynamic_title = true;

        # Window class (Linux/BSD only):

        class = {
          
          # Application instance name
          
          instance = "Alacritty";

          # General application class
          
          general = "Alacritty";
        };

        # Decorations theme variant
        #
        # Override the variant of the System theme/GTK theme/Wayland client side
        # decorations. Commonly supported values are `Dark`, `Light`, and `None` for
        # auto pick-up. Set this to `None` to use the default theme variant.
        
        decorations_theme_variant = "Dark";

        # Resize increments
        #
        # Prefer resizing window by discrete steps equal to cell dimensions.
        
        resize_increments = false;

        # Make `Option` key behave as `Alt` (macOS only):
        #   - OnlyLeft
        #   - OnlyRight
        #   - Both
        #   - None (default)
        
        #option_as_alt = "None";
      
      };

      scrolling = {
        # Maximum number of lines in the scrollback buffer.
        # Specifying '0' will disable scrolling.
        history = 10000;

        # Scrolling distance multiplier.
      
        multiplier = 3;
      };

      # Font configuration
      font = {

        # Normal (roman) font face

        normal = {

          # Font family
          #
          # Default:
          #   - (macOS) Menlo
          #   - (Linux/BSD) monospace
          #   - (Windows) Consolas
          
          family = "${normalFontFamily}";

          # The `style` can be specified to pick a specific face.

          style = "Regular";
        };

        # Bold font face

        bold = {

          # Font family
          #
          # If the bold family is not specified, it will fall back to the
          # value specified for the normal font.

          family = "${boldFontFamily}";

          # The `style` can be specified to pick a specific face.

          style = "Bold";
        };

        # Italic font face
        
        italic = {
          # Font family
          #
          # If the italic family is not specified, it will fall back to the
          # value specified for the normal font.
          
          family = "${italicFontFamily}";

          # The `style` can be specified to pick a specific face.
          
          style = "Italic";
        };

        # Bold italic font face
        
        bold_italic = {
          
          # Font family
          #
          # If the bold italic family is not specified, it will fall back to the
          # value specified for the normal font.
          
          family = "${boldItalicFontFamily}";

          # The `style` can be specified to pick a specific face.
          
          style = "Bold Italic";
        };

        # Point size

        size = 9.0;

        # Offset is the extra space around each character. `offset.y` can be thought
        # of as modifying the line spacing, and `offset.x` as modifying the letter
        # spacing.
        
        offset = {
          x = 0;
          y = 0;
        };

        # Glyph offset determines the locations of the glyphs within their cells with
        # the default being at the bottom. Increasing `x` moves the glyph to the
        # right, increasing `y` moves the glyph upward.
        
        glyph_offset = {
          x = 0;
          y = 0;
        };

        # Use built-in font for box drawing characters.
        #
        # If `true`, Alacritty will use a custom built-in font for box drawing
        # characters (Unicode points 2500 - 259f).
        #
        
        builtin_box_drawing = true;
      };

      # If `true`, bold text is drawn using the bright color variants.
      
      draw_bold_text_with_bright_colors = false;

      # Colors (Rosé Pine Moon)

      colors = {

        # Default colors
        
        primary = {

          background = "#232136";
          foreground = "#e0def4";

          # Bright and dim foreground colors
          #
          # The dimmed foreground color is calculated automatically if it is not
          # present. If the bright foreground color is not set, or
          # `draw_bold_text_with_bright_colors` is `false`, the normal foreground
          # color will be used.
          
          #dim_foreground = "#828482";
          #bright_foreground = "#eaeaea";
        };

        # Cursor colors
        #
        # Colors which should be used to draw the terminal cursor.
        #
        # Allowed values are CellForeground/CellBackground, which reference the
        # affected cell, or hexadecimal colors like #ff00ff.

        cursor = {
          text = "#e0def4";
          cursor = "#56526e";
        };

        # Vi mode cursor colors
        #
        # Colors for the cursor when the vi mode is active.
        #
        # Allowed values are CellForeground/CellBackground, which reference the
        # affected cell, or hexadecimal colors like #ff00ff.

        vi_mode_cursor = {
          text = "#e0def4";
          cursor = "#56526e";
        };

        # Search colors
        #
        # Colors used for the search bar and match highlighting.

        /*
        search = {

          # Allowed values are CellForeground/CellBackground, which reference the
          # affected cell, or hexadecimal colors like #ff00ff.
          
          matches = {
            foreground = "#000000";
            background = "#ffffff";
          };
          focused_match = {
            foreground = "#ffffff";
            background = "#000000";
          };
        };
        */

        # Keyboard hints

        hints = {

          # First character in the hint label
          #
          # Allowed values are CellForeground/CellBackground, which reference the
          # affected cell, or hexadecimal colors like #ff00ff.

          start = {
            foreground = "#908caa";
            background = "#2a273f";
          };

          # All characters after the first one in the hint label
          #
          # Allowed values are CellForeground/CellBackground, which reference the
          # affected cell, or hexadecimal colors like #ff00ff.

          end = {
            foreground = "#6e6a86";
            background = "#2a273f";
          };
        };

        # Line indicator
        #
        # Color used for the indicator displaying the position in history during
        # search and vi mode.
        #
        # By default, these will use the opposing primary color.

        line_indicator = {
          foreground = "None";
          background = "None";
        };

        # Footer bar
        #
        # Color used for the footer bar on the bottom, used by search regex input,
        # hyperlink URI preview, etc.

        /*
        footer_bar = {
          background = "#c5c8c6";
          foreground = "#1d1f21";
        };
        */

        # Selection colors
        #
        # Colors which should be used to draw the selection area.
        #
        # Allowed values are CellForeground/CellBackground, which reference the
        # affected cell, or hexadecimal colors like #ff00ff.

        selection = {
          text = "#e0def4";
          background = "#44415a";
        };

        # Normal colors
        
        normal = {
          black =   "#393552";
          red =     "#ce6180";
          green =   "#56b455";
          yellow =  "#d7a968";
          blue =    "#89b5bd";
          magenta = "#ac92ca";
          cyan =    "#cd8784";
          white =   "#c4c2d6";
        };

        # Bright colors

        bright = {
          black =   "#6e6a86";
          red =     "#eb6f92";
          green =   "#62ce61";
          yellow =  "#f6c177";
          blue =    "#9ccfd8";
          magenta = "#c4a7e7";
          cyan =    "#ea9a97";
          white =   "#e0def4";
        };

        # Dim colors
        #
        # If the dim colors are not set, they will be calculated automatically based
        # on the `normal` colors.
        #dim:
        #  black:   '#131415'
        #  red:     '#864343'
        #  green:   '#777c44'
        #  yellow:  '#9e824c'
        #  blue:    '#556a7d'
        #  magenta: '#75617b'
        #  cyan:    '#5b7d78'
        #  white:   '#828482'

        # Indexed Colors
        #
        # The indexed colors include all colors from 16 to 256.
        # When these are not set, they're filled with sensible defaults.
        #
        # Example:
        #   `- { index: 16, color: '#ff00ff' }`
        #
        #indexed_colors: []

        # Transparent cell backgrounds
        #
        # Whether or not `window.opacity` applies to all cell backgrounds or only to
        # the default background. When set to `true` all cells will be transparent
        # regardless of their background color.

        transparent_background_colors = false;
      };

      # Bell
      #
      # The bell is rung every time the BEL control character is received.
      #bell = {
        # Visual Bell Animation
        #
        # Animation effect for flashing the screen when the visual bell is rung.
        #
        # Values for `animation`:
        #   - Ease
        #   - EaseOut
        #   - EaseOutSine
        #   - EaseOutQuad
        #   - EaseOutCubic
        #   - EaseOutQuart
        #   - EaseOutQuint
        #   - EaseOutExpo
        #   - EaseOutCirc
        #   - Linear
        #animation: EaseOutExpo

        # Duration of the visual bell flash in milliseconds. A `duration` of `0` will
        # disable the visual bell animation.
        #duration: 0

        # Visual bell animation color.
        #color: '#ffffff'

        # Bell Command
        #
        # This program is executed whenever the bell is rung.
        #
        # When set to `command: None`, no command will be executed.
        #
        # Example:
        #   command:
        #     program: notify-send
        #     args: ["Hello, World!"]
        #
        #command: None
      #};

      selection = {
        # This string contains all characters that are used as separators for
        # "semantic words" in Alacritty.
        #semantic_escape_chars: ",│`|:\"' ()[]{}<>\t"

        # When set to `true`, selected text will be copied to the primary clipboard.
        
        save_to_clipboard = true;
      };

      cursor = {

        # Cursor style

        style = {

          # Cursor shape
          #
          # Values for `shape`:
          #   - ▇ Block
          #   - _ Underline
          #   - | Beam

          shape = "Block";

          # Cursor blinking state
          #
          # Values for `blinking`:
          #   - Never: Prevent the cursor from ever blinking
          #   - Off: Disable blinking by default
          #   - On: Enable blinking by default
          #   - Always: Force the cursor to always blink

          blinking = "On";
        };

        # Vi mode cursor style
        #
        # If the vi mode cursor style is `None` or not specified, it will fall back to
        # the style of the active value of the normal cursor.
        #
        # See `cursor.style` for available options.
        #vi_mode_style: None

        # Cursor blinking interval in milliseconds.
        #blink_interval: 750

        # Time after which cursor stops blinking, in seconds.
        #
        # Specifying '0' will disable timeout for blinking.
        #blink_timeout: 5

        # If this is `true`, the cursor will be rendered as a hollow box when the
        # window is not focused.
        
        unfocused_hollow = true;

        # Thickness of the cursor relative to the cell width as floating point number
        # from `0.0` to `1.0`.
        #thickness: 0.15
      };

      # Live config reload (changes require restart)
      
      live_config_reload = false;

      # Shell
      #
      # You can set `shell.program` to the path of your favorite shell, e.g.
      # `/bin/fish`. Entries in `shell.args` are passed unmodified as arguments to the
      # shell.
      #
      # Default:
      #   - (Linux/BSD/macOS) `$SHELL` or the user's login shell, if `$SHELL` is unset
      #   - (Windows) powershell
      
      #shell:
      #  program: /bin/bash
      #  args:
      #    - --login

      # Startup directory
      #
      # Directory the shell is started in. If this is unset, or `None`, the working
      # directory of the parent process will be used.
      #working_directory: None

      # Offer IPC using `alacritty msg` (unix only)
      #ipc_socket: true

      #mouse =
        # Click settings
        #
        # The `double_click` and `triple_click` settings control the time
        # alacritty should wait for accepting multiple clicks as one double
        # or triple click.
        #double_click: { threshold: 300 }
        #triple_click: { threshold: 300 }

        # If this is `true`, the cursor is temporarily hidden when typing.
        #hide_when_typing: false
      #};

      # Hints
      #
      # Terminal hints can be used to find text or hyperlink in the visible part of
      # the terminal and pipe it to other applications.

      #hints = {
        # Keys used for the hint labels.
        #alphabet: "jfkdls;ahgurieowpq"

        # List with all available hints
        #
        # Each hint must have any of `regex` or `hyperlinks` field and either an
        # `action` or a `command` field. The fields `mouse`, `binding` and
        # `post_processing` are optional.
        #
        # The `hyperlinks` option will cause OSC 8 escape sequence hyperlinks to be
        # highlighted.
        #
        # The fields `command`, `binding.key`, `binding.mods`, `binding.mode` and
        # `mouse.mods` accept the same values as they do in the `key_bindings` section.
        #
        # The `mouse.enabled` field controls if the hint should be underlined while
        # the mouse with all `mouse.mods` keys held or the vi mode cursor is above it.
        #
        # If the `post_processing` field is set to `true`, heuristics will be used to
        # shorten the match if there are characters likely not to be part of the hint
        # (e.g. a trailing `.`). This is most useful for URIs and applies only to
        # `regex` matches.
        #
        # Values for `action`:
        #   - Copy
        #       Copy the hint's text to the clipboard.
        #   - Paste
        #       Paste the hint's text to the terminal or search.
        #   - Select
        #       Select the hint's text.
        #   - MoveViModeCursor
        #       Move the vi mode cursor to the beginning of the hint.
        #enabled:
        # - regex: "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)\
        #           [^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+"
        #   hyperlinks: true
        #   command: xdg-open
        #   post_processing: true
        #   mouse:
        #     enabled: true
        #     mods: None
        #   binding:
        #     key: U
        #     mods: Control|Shift
      #};

      #debug = {
        # Display the time it takes to redraw each frame.
        #render_timer: false

        # Keep the log file after quitting Alacritty.
        #persistent_logging: false

        # Log level
        #
        # Values for `log_level`:
        #   - Off
        #   - Error
        #   - Warn
        #   - Info
        #   - Debug
        #   - Trace
        #log_level: Warn

        # Renderer override.
        #   - glsl3
        #   - gles2
        #   - gles2_pure
        #renderer: None

        # Print all received window events.
        #print_events: false

        # Highlight window damage information.
        #highlight_damage: false
      #};
    };
  };
}
