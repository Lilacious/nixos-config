{ lib, ... }:
with lib;
{
  options.full = {
    enable = mkEnableOption "full nixvim configuration";
  };

  imports = [
    ./clipboard.nix
    ./cmp.nix
    ./general.nix
    ./lsp.nix
    ./keymaps.nix
    ./options.nix
    ./plugins.nix
    ./telescope.nix
  ];
}
