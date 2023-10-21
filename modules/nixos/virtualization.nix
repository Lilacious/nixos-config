{ pkgs, variables, ... }:
{
# Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ 
    virt-manager
  ];
  users.users.${variables.username}.extraGroups = [ "libvirtd" ];
}
