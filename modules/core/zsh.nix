# For home config see nix-config/home/programs/zsh.nix
{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myModules.core.zsh;
in {
  options.myModules.core.zsh.enable = mkOption {
    type = types.bool;
    default = config.myModules.enable;
  };
  config = mkIf cfg.enable {
    ## For programs.zsh.enableCompletion
    environment.pathsToLink = ["/share/zsh"];
    ## Enable zsh system-wide
    programs.zsh.enable = true;
  };
}
