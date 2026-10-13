# Shared base for all profiles, `class` selects the matching module set
# of the flake inputs: "nixos", "darwin" or "home" (home-manager)
class:
{
  inputs,
  lib,
  ...
}:
let
  moduleSet =
    {
      nixos = {
        nixvim = "nixosModules";
        stylix = "nixosModules";
        home-manager = "nixosModules";
      };
      darwin = {
        nixvim = "nixDarwinModules";
        stylix = "darwinModules";
        home-manager = "darwinModules";
      };
      home = {
        nixvim = "homeModules";
        stylix = "homeModules";
      };
    }
    .${class};
in
{
  imports = [
    inputs.nixvim.${moduleSet.nixvim}.nixvim
    ../modules/vim

    inputs.stylix.${moduleSet.stylix}.stylix
    ../modules/stylix
  ]
  # core modules and home-manager are system-level only
  ++ lib.optionals (class != "home") [ # if Nixos or Darwin
    ../modules/core

    # resolves to nixosModules or darwinModules
    inputs.home-manager.${moduleSet.home-manager}.home-manager
    {
      # set home-manager.users.<name> entry to get home-manager
      # move to base to avoid duplicate code
      home-manager = {
        extraSpecialArgs = { inherit inputs; };
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ { home.stateVersion = lib.mkDefault "23.05"; } ];
      };
    }
  ];
}
