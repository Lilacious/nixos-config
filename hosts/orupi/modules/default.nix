{
  imports = [
    ./adguard.nix
    ./komga.nix
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "yuchenhe126@gmail.com";

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

}
