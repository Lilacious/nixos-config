# Shared base for all profiles, `class` selects the matching module set
# of the flake inputs: "nixos", "darwin" or "home" (home-manager)
class:
{
  inputs,
  ...
}:
let
  moduleSet =
    {
      nixos = {
        nixvim = "nixosModules";
        stylix = "nixosModules";
      };
      darwin = {
        nixvim = "nixDarwinModules";
        stylix = "darwinModules";
      };
      home = {
        nixvim = "homeModules";
        stylix = "homeModules";
      };
    }
    .${class};
in
{
  # core modules are system-level only
  imports = (if class == "home" then [ ] else [ ../modules/core ]) ++ [
    inputs.nixvim.${moduleSet.nixvim}.nixvim
    ../modules/vim

    inputs.stylix.${moduleSet.stylix}.stylix
    ../modules/stylix
  ];
}
