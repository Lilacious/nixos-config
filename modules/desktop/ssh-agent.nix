{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.myModules.desktop;
in
{
  options = {
    myModules.desktop.sshAgent = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
      };
    };
  };

  config = mkIf cfg.sshAgent.enable {
    programs.ssh = {
      # gnome-keyring brings its own agent, both cannot be enabled
      startAgent = mkDefault (!config.services.gnome.gcr-ssh-agent.enable);
      # GNOME and Plasma both set askPassword, which fails to evaluate
      # when both are enabled, prefer ksshaskpass
      askPassword = mkIf (config.programs.seahorse.enable && cfg.plasma.enable) (
        mkOverride 999 "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass"
      );
      extraConfig = ''
        AddKeysToAgent 4h
      '';
    };
  };
}
