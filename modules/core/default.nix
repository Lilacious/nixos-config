# Core folder contains common packages and services
# used by most hosts.
{
  imports = [
    ./common.nix
    ./neovim.nix
    ./nix.nix
  ];
}
