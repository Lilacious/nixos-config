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
    nur.url = "github:nix-community/NUR";
  };

  outputs = { 
    self, nixpkgs, 
    home-manager, nixos-hardware, agenix, 
    plasma-manager, nur, 
    ... 
  }@inputs:
  let
    variables = {
      username = "yunix";
      shell = "zsh";
      email = "yuchenhe126@gmail.com";
    };
  in {
    nixosConfigurations = (
      import ./hosts { 
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs variables;
        inherit home-manager nixos-hardware agenix;
        inherit plasma-manager nur;
      }
    );
  };
}
