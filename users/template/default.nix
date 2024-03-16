{pkgs, ...}: {
  users.users.max = {
    isNormalUser = true;
    description = "Max Mustermann";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    initialPassword = "changeme";
    shell = pkgs.bashInteractive;
  };

  imports = [
    ./home.nix
  ];
}
