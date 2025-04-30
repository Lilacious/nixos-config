{
  inputs,
  ...
}:
{
  imports = [
    ../modules/core
    ../modules/vim
    inputs.nixvim.nixosModules.nixvim

    ../users/wsl
  ];
}
