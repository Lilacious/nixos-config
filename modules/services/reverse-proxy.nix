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
        assertion = cfg.enable -> cfg.acmeEmail != null;
        message = ''
          myModules.services.nginx.acmeEmail has to be set if myModules.services.nginx is enabled.
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
      recommendedZstdSettings = mkDefault true;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.enable [
      80
      443
    ];
  };
}
