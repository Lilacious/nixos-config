{pkgs, ...}: {
  users.users.yunix = {
    isNormalUser = true;
    description = "Yunix";
    extraGroups = [
      "corectrl"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };

  imports = [
    ./home.nix
    ./syncthing.nix
  ];
}
