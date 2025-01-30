{
  performance.byteCompileLua = {
    enable = true;
    plugins = true;
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
}
