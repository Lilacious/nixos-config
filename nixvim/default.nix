{ inputs, ... }:
let
  inherit (inputs) nixvim;
in
{
  perSystem =
    { system, ... }:
    let
      inherit (nixvim.legacyPackages.${system})
      makeNixvimWithModule;

      nixvimModule = {
        inherit system;
        module = import ./nixvim.nix;
        extraSpecialArgs = {
          # inherit (inputs) foo;
        };
      };

      nvim = makeNixvimWithModule nixvimModule;
    in
    {
      packages = {
        nixvim = nvim;
      };
    };
}
