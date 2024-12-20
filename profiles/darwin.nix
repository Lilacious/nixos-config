{
  inputs,
  ...
}:
{
  imports = [
    ../modules/core
    ../modules/core/vim
    inputs.nixvim.nixDarwinModules.nixvim

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }

    ../users/yunix
  ];
}
