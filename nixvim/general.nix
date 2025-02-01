{
  config = {
    viAlias = true;
    vimAlias = true;

    performance.byteCompileLua = {
      enable = true;
      plugins = true;
      configs = true;
      nvimRuntime = true;
    };

    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          term_colors = true;
        };
      };
    };

    # Leader key <Space>
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
  };
}
