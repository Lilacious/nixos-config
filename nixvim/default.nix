{ inputs, ... }:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
  };

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations = {
        nixvim = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            ./clipboard.nix
            ./general.nix
            ./keymaps.nix
          ];
        };
      };
    };
}
