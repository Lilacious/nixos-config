# remembers ssh key password for 4h
{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.myModules.programs.sshAgent;
in
{
  options = {
    myModules.programs.sshAgent = {
      enable = mkEnableOption "ssh-agent with a 4h key lifetime";
    };
  };

  # nix-darwin has no programs.ssh.startAgent
  config = optionalAttrs (options.programs.ssh ? startAgent) (
    mkIf cfg.enable {
      programs.ssh = {
        startAgent = true;
        extraConfig = ''
          AddKeysToAgent 4h
        '';
      };
    }
  );
}
