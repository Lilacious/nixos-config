{ pkgs, ... }:
{
  # nix develope
  devShells.nix = pkgs.mkShell {
    packages = with pkgs; [
      deadnix # Find and remove unused code in nix files
      statix # Lints and suggestions for nix-lang
      nixpkgs-review # review nixpkgs pr
      nix-init # package generation
    ];
  };
  formatter = pkgs.nixfmt-rfc-style;
}
