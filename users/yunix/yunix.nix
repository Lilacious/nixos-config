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
        Enable the the Yunix user.
      '';
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
  };
}
