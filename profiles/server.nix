{
  imports = [
    ./nixos.nix
    ../modules/services

    ../users/yunix/headless.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };
  # Don't use the hm module on servers user systemd service
  # is only active if the user is logged in (through ssh).
  myModules.services.syncthing.enable = true;
}
