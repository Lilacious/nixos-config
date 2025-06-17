{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.services.podman;
in
{
  options = {
    myModules.services.podman = {
      enable = mkEnableOption "podman";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };
    # Service to manually update podman containers
    # Warning: it won't work if the `serviceName` is modified or if backend is docker.
    systemd.services.update-containers = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = getExe (
          pkgs.writeShellScriptBin "update-containers" ''
            images=$(${pkgs.podman}/bin/podman ps -a --format="{{.Image}}" | sort -u)

            for image in $images; do
              ${pkgs.podman}/bin/podman pull "$image"
              ${pkgs.systemd}/bin/systemctl try-restart\
                podman-$(${pkgs.gawk}/bin/awk -F'[/:]' '{print $(NF-1)}'\
                <<< $image).service && echo Finished restarting $_
            done
          ''
        );
      };
    };
  };
}
