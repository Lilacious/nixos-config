{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  stablepkgs = inputs.stable.legacyPackages.${pkgs.system};
in
{
  ## GPU passthrough
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
    "kvm-amd"
    "amd_iommu_v2"
    "iommu_v2"
  ];

  ## Isolate guest GPU
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:2782,10de:22bc
  '';

  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "nvidiafb"
  ];

  ## Looking Glass
  home-manager.users.yunix = {
    programs.looking-glass-client = {
      enable = true;
      package = stablepkgs.looking-glass-client;
      settings = {
        win = {
          fullScreen = true;
          size = "2560x1440";
          #size = "1920x1080";
        };
      };
    };

    ## Override Looking Glass desktop entry
    xdg.desktopEntries = {
      looking-glass-client = {
        exec = "looking-glass-client";
        icon = "lg-logo";
        name = "Looking Glass Client";
        terminal = false;
        type = "Application";
      };
    };
  };

  ## Looking Glass shared mem permission
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 yunix kvm -"
  ];

  myModules.programs.virt-manager.enable = mkForce true;

  environment.systemPackages = with pkgs; [
    libguestfs-with-appliance
  ];

  virtualisation = {
    libvirtd = {
      qemu = {
        ## TPM emulation
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  ## Clipboard sync
  services.spice-vdagentd.enable = true;
}
