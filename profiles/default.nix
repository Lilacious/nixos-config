{
  flake.nixosModules = {
    nixos = import ./nixos.nix;
    server = import ./server.nix;
    workstation = import ./workstation.nix;
    wsl = import ./wsl.nix;
  };
}
