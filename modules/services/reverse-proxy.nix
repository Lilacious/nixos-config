{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myModules.services.reverseProxy;
in
{
  options = {
    myModules.services.reverseProxy = {
      enable = mkEnableOption "nginx reverse proxy";
      acmeEmail = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      openFirewall = mkEnableOption "open nginx firewall" // {
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.acmeEmail != null;
        message = ''
          myModules.services.reverseProxy.acmeEmail has to be set if myModules.services.reverseProxy is enabled.
        '';
      }
    ];

    security.acme.acceptTerms = true;
    security.acme.defaults.email = mkDefault cfg.acmeEmail;

    services.nginx = {
      enable = true;
      recommendedBrotliSettings = mkDefault true;
      recommendedGzipSettings = mkDefault true;
      recommendedOptimisation = mkDefault true;
      recommendedProxySettings = mkDefault true;
      recommendedTlsSettings = mkDefault true;
      recommendedUwsgiSettings = mkDefault false;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      80
      443
    ];
  };
}
