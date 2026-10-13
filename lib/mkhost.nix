# Host constructors
{ self, inputs }:
let
  inherit (inputs.nixpkgs) lib;

  # Shared host settings, `system` may be omitted if the
  # hardware configuration already sets nixpkgs.hostPlatform
  hostModule = name: system: {
    networking.hostName = lib.mkDefault name;
    nixpkgs.hostPlatform = lib.mkIf (system != null) system;
  };
in
{
  mkNixos =
    name:
    {
      profile,
      system ? null,
      modules ? [ ],
      specialArgs ? { },
    }:
    lib.nixosSystem {
      specialArgs = { inherit self inputs; } // specialArgs;
      modules = modules ++ [
        self.nixosModules.${profile}
        (hostModule name system)
      ];
    };

  mkDarwin =
    name:
    {
      system ? "aarch64-darwin",
      modules ? [ ],
      specialArgs ? { },
    }:
    inputs.darwin.lib.darwinSystem {
      specialArgs = { inherit self inputs; } // specialArgs;
      modules = modules ++ [
        self.darwinModules.darwin
        (hostModule name system)
      ];
    };
}
