{pkgs, ...}: {
  system.stateVersion = "23.11";

  networking.hostName = "sisyphos";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  networking.firewall = {
    allowedTCPPorts = [22];
  };

  environment.systemPackages = with pkgs; [
    steamPackages.steamcmd
  ];
}
