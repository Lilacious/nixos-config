{
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      bind_port = 8080;
      http.address = "0.0.0.0:8080";
      schema_version = 20;
    };
  };
  
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.nginx = {
    virtualHosts."adguard.local" =  {
      locations."/" = {
        proxyPass = "http://localhost:8080";
      };
    };
  };
}
