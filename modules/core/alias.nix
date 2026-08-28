{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.core;
in
{
  environment.shellAliases = mkIf cfg.enable (mkMerge [
    {
      c = "clear";
      neofetch = "fastfetch";
    }
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";

      netstat = "ss";
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      update = "cd ~/nixos-config && darwin-rebuild switch --flake .#$HOST";
    })
  ]);
}
