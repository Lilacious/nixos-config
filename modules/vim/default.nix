{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./clipboard.nix
    ./keymaps.nix
    ./lsp-cmp.nix
    ./nvim-tree.nix
    ./options.nix
    ./plugins.nix
    ./telescope.nix
  ];

  programs.nixvim = mkMerge [
    {
      enable = true;
      viAlias = true;
      vimAlias = true;

      performance.byteCompileLua = {
        enable = true;
        plugins = true;
        configs = true;
        nvimRuntime = true;
      };

      # Leader key <Space>
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
    }
    (mkIf pkgs.stdenv.isLinux {
      defaultEditor = true;
    })
  ];
}
