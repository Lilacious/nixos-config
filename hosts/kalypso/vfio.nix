{ variables, lib, pkgs, ... }:
with lib;
{
  ## GPU passthrough
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:2782,10de:22bc
  '';
  
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${variables.username} kvm -"
  ];
  myModules.services.virtualization.enable = mkForce true;

  environment.systemPackages = with pkgs; [
    libguestfs-with-appliance
    looking-glass-client
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
