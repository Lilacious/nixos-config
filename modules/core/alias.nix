{
  lib,
  pkgs,
  ...
}:
with lib;
{
  environment.shellAliases = mkMerge [
    {
      c = "clear";
      neofetch = "fastfetch";
    }
    (mkIf pkgs.stdenv.isLinux {
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
    })
    (mkIf pkgs.stdenv.isDarwin {
      update = "cd ~/nixos-config && darwin-rebuild switch --flake .#$HOST";
    })
  ];
}
