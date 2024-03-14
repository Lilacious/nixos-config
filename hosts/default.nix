{ inputs, nixpkgs, ... }:
let
  lib = nixpkgs.lib;
in {        
  ## penelope, laptop, workstation, Thinkpad T480
  penelope = lib.nixosSystem ( 
    import ./penelope { inherit inputs; }
  );

  ## kalypso, workstation
  kalypso = lib.nixosSystem (
    import ./kalypso { inherit inputs; }
  );

  ## hades, nas, server
  hades = lib.nixosSystem (
    import ./hades { inherit inputs; }
  );

  ## orupi, server
  orupi = lib.nixosSystem (
    import ./orupi { inherit inputs; }
  );

  # sisyphos, builder
  sisyphos = lib.nixosSystem (
    import ./orupi { inherit inputs; }
  );

  ## rlang, other
  rlang = lib.nixosSystem (
    import ./rlang {}
  );

  ## Add new hosts here
}
