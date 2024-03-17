{pkgs, ...}: {
  system.stateVersion = "23.05";

  security.doas.enable = false;

  networking.hostName = "hades";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
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
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };

  # btrfs zstd compression
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/swap".options = ["noatime"];
  };
  swapDevices = [{device = "/swap/swapfile";}];

  boot.zfs.extraPools = ["data"];

  services.zfs.autoScrub.enable = true;

  services.zfs.trim.enable = true;

  boot.supportedFilesystems = ["zfs"];

  networking.hostId = "d93a8103";

  # disk spin-down
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 180 /dev/disk/by-id/ata-WDC_WD20EFRX-68EUZN0_WD-WCC4M5TR0YYR
    ${pkgs.hdparm}/sbin/hdparm -S 180 /dev/disk/by-id/ata-WDC_WD20EFRX-68EUZN0_WD-WCC4M6SETN2A
  '';

  powerManagement = {
    # powertop autotune
    powertop.enable = true;
    # SATA Active Link Power Management
    #scsiLinkPolicy = "med_power_with_dipm";
    scsiLinkPolicy = "min_power";
    cpuFreqGovernor = "ondemand";
  };

  boot.kernelParams = [
    "intel_pstate=disable"
    "nvme_load=YES"
    "nvme_core.default_ps_max_latency_us=500"
    "pcie_aspm=powersave"
  ];

  systemd.services.ethaspm = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.coreutils];
    enable = true;
    serviceConfig = {
      User = "root";
      Group = "root";
    };
    script = ''
      echo '1' > '/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/l1_2_aspm'
      echo '1' > '/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/link/l1_2_aspm'
    '';
  };
}
