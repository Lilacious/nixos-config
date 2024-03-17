{
  services.komga = {
    enable = true;
    port = 10080;
    openFirewall = true;
  };

  services.nginx = {
    virtualHosts."komga.local" = {
      locations."/" = {
        proxyPass = "http://localhost:10080";
      };
    };
  };

  ## Samba share
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      server string = orupi
      netbios name = orupi
      hosts allow = 192.168.178. 127.0.0.1 localhost
    '';
    shares = {
      komga = {
        path = "/var/lib/komga";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "komga";
      };
    };
  };
}
