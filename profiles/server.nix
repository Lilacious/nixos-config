{
  imports = [
    ./nixos.nix
    ../modules/services

    ../users/yunix/headless.nix
  ];

  # Show failed systemd units on interactive login
  environment.interactiveShellInit = ''
    echo "\nFailed systemd units:" && \
      systemctl --no-pager --failed || true
  '';

  documentation = {
    # html docs and info are not required, man pages are enough
    doc.enable = false;
    info.enable = false;
  };

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
