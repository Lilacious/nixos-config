{
  inputs,
  ...
}:
{
  imports = [
    ../modules/core
    ../modules/core/vim
    inputs.nixvim.nixosModules.nixvim

    ../users/wsl
  ];
}
