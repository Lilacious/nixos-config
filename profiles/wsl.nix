{
  inputs,
  ...
}:
{
  imports = [
    ./nixos.nix
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;

  # Fix VSCode WSL
  programs.nix-ld.enable = true;
}
