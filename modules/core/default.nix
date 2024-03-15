# Core folder contains common packages and services
# used by most hosts.
{
  imports = [
    ./common.nix
    ./locale.nix
    ./neovim.nix
    ./nix.nix
  ];
}
