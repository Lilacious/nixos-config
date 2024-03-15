{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.myUsers.yunix;
in {
  options.myUsers.yunix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable the Yunix user.
      '';
    };
    options.myUsers.yunix = {
      disableHomeManager = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Disable home-manager the Yunix user.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.yunix = {
      isNormalUser = true;
      description = "Yunix";
      extraGroups = [
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
      ];
      initialPassword = "changeme";
      shell = "zsh";
    };

    home-manager.users.yunix = mkIf (!cfg.disableHomeManager) {
      home.username = "yunix";
      home.homeDirectory = "${config.users.users.yunix.home}";
      home.stateVersion = "23.05";
    };
  };
}
