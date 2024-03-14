{ config, lib, pkgs, ... }:
with lib;
{
  ## GPU passthrough
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  ## Isolate guest GPU
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:2782,10de:22bc
  '';

  ## Looking Glass
  home-manager.users.${config.variables.username} = {
    programs.looking-glass-client = {
      enable = true;
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
    "f /dev/shm/looking-glass 0660 ${config.variables.username} kvm -"
  ];

  myModules.services.virtualization.enable = mkForce true;

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
