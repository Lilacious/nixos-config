{
  programs.nixvim = {
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          term_colors = true;
        };
      };
    };

    plugins = {
      # telescope and tree dependency
      web-devicons.enable = true;
      # Reopens at last edit position
      lastplace.enable = true;
      # Statusline/tabline plugin for Vim
      lightline = {
        enable = true;
        settings.colorscheme = "catppuccin";
      };
      # Indent guides for Neovim
      indent-blankline.enable = true;
      # Neovim colorizer
      nvim-colorizer.enable = true;
      # Useful plugin to show you pending keybinds
      which-key = {
        enable = true;
        settings.delay = 0;
      };
      # Git signs in the side bar
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = "+";
            };
            change = {
              text = "~";
            };
            delete = {
              text = "_";
            };
            topdelete = {
              text = "‾";
            };
            changedelete = {
              text = "~";
            };
          };
        };
      };
    };
  };
}