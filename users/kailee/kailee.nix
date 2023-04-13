{ pkgs, ... }:
{ 
  users.users.kailee = {
    isNormalUser = true;
    description = "kailee";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
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
