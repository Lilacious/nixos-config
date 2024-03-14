{
  description = "My really basic flaky flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };
  };

  outputs = { 
    self, nixpkgs, 
    home-manager, nixos-hardware, agenix, 
    plasma-manager, 
    ... 
  }@inputs:
  {
    nixosConfigurations = (
      import ./hosts { 
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs;
      }
    );
  };
}
