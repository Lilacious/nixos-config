# For home config see home/core/zsh.nix
{ config, lib, ... }:
with lib;
let
  cfg = config.myModules.core;
in
{
  config = mkIf cfg.enable {
    ## For programs.zsh.enableCompletion
    environment.pathsToLink = [ "/share/zsh" ];
    ## Enable zsh system-wide
    programs.zsh.enable = true;
  };
}
