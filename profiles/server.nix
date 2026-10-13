{
  imports = [
    ./nixos.nix
    ../modules/services

    ../users/yunix
  ];

  # Show failed systemd units on interactive login
  environment.loginShellInit = ''
    printf "\nFailed systemd units:\n"
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
      PermitRootLogin = "no";
    };
  };
}
