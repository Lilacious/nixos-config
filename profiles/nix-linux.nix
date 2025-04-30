## Only import through home-manager
{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../modules/vim
  ];
}
