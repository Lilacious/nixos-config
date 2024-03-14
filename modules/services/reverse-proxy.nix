{ config, lib, ... }:

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
    security.acme.defaults.email = "${config.variables.email}";

    services.nginx = {
      enable = true;
      recommendedGzipSettings = mkDefault true;
      recommendedOptimisation = mkDefault true;
      recommendedProxySettings = mkDefault true;
      recommendedTlsSettings = mkDefault true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
