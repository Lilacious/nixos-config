{ pkgs, ... }:
{
  environment.variables = { 
    EDITOR = "vim"; 
  };

  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ 
            ## Reopens at last edit position
            vim-lastplace           
            ## Support for writing Nix expressions
            vim-nix
            ## Surround selections
            nvim-surround
            ## File system explorer
            nerdtree
            ## Catppuccin theme for nvim
            catppuccin-nvim
            ## Insert or delete brackets, parens, quotes in pair
            auto-pairs
            ## Statusline/tabline plugin for Vim
            lightline-vim
            ## Indent guide
            indent-blankline-nvim
            ## File type icon
            vim-devicons
          ]; 
        };
        customRC = ''
          set nocompatible
          set backspace=indent,eol,start
          set number

          "" Clipboard support
          set clipboard=unnamedplus

          "" Set color scheme
          colorscheme catppuccin-mocha

          "" move between panes to left/bottom/top/right
          nnoremap <A-h> <C-w>h
          nnoremap <A-j> <C-w>j
          nnoremap <A-k> <C-w>k
          nnoremap <A-l> <C-w>l

          "" Nerdtree config
          "" Exit Vim if NERDTree is the only window remaining in the only tab.
          autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1
            \ && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
          
          "" Toggle Nerdtree
          nnoremap <MiddleMouse> :NERDTreeToggle<CR>

          "" lightline config
          let g:lightline = {'colorscheme': 'catppuccin'}
          "" lua settings
          lua << EOF
          -- indent-blankline-nvim setup
          require("ibl").setup()
          EOF
        '';
      };
    })

    ## Clipboard
    wl-clipboard
    xclip
  ];
}
