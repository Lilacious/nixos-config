{
  inputs,
  ...
}:
{
  imports = [
    ../modules/core

    inputs.nixvim.nixosModules.nixvim
    ../modules/vim

    inputs.stylix.nixosModules.stylix
    ../modules/stylix

    ../users/wsl
  ];

  # Fix VSCode WSL
  programs.nix-ld.enable = true;
}
