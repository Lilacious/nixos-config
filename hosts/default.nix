{ inputs, variables, nixpkgs, ... }:
let
  lib = nixpkgs.lib;
in {        
  ## penelope, laptop, workstation, Thinkpad T480
  penelope = lib.nixosSystem ( 
    import ./penelope { inherit inputs variables; }
  );

  ## kalypso, workstation
  kalypso = lib.nixosSystem (
    import ./kalypso { inherit inputs variables; }
  );

  ## hades, nas, server
  hades = lib.nixosSystem (
    import ./hades { inherit inputs variables; }
  );

  ## orupi, server
  orupi = lib.nixosSystem (
    import ./orupi { inherit inputs variables; }
  );

  # sisyphos, builder
  sisyphos = lib.nixosSystem (
    import ./orupi { inherit inputs variables; }
  );

  ## rlang, other
  rlang = lib.nixosSystem {
    specialArgs = { 
      system = "x86_64-linux";
    };
    modules = [
      ./rlang/configuration.nix
    ];
  };
  ## Add new hosts here
}
