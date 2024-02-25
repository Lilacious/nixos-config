{ config, lib, variables, ... }:

with lib;
let
  cfg = config.myModules.services.reverseProxy;
in
{
  options = {
    myModules.services.reverseProxy = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "${variables.email}";

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
