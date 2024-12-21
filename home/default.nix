# Please import home through a user
{
  flake.nixosModules = {
    home-core = import ./core;
    home-desktop = import ./desktop;
    home-programs = import ./programs;
  };
}
