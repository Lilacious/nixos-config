# For home config see nix-config/home/programs/zsh.nix
{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules;
in {
  config = mkIf cfg {
    ## For programs.zsh.enableCompletion
    environment.pathsToLink = ["/share/zsh"];
    ## Enable zsh system-wide
    programs.zsh.enable = true;
  };
}
