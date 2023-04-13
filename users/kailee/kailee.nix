{ pkgs, ... }:
{ 
  users.users.kailee = {
    isNormalUser = true;
    description = "kailee";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      keepassxc
      jetbrains.idea-ultimate
      vscodium
    #  thunderbird
    ];
  };
}
