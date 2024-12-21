{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  username = "yunix";
  gitFile = ../users/${username}/git.nix;
in
{
  imports = [
    ./nixos.nix
    ../modules

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${username} = {
          home = {
            username = "${username}";
            homeDirectory = "${config.users.users.${username}.home}";
            stateVersion = "23.05";
          };
          imports = [
            ../home
          ] ++ optional (builtins.pathExists gitFile) gitFile;
        };
      };
    }

    ../users/${username}
  ];

  environment.systemPackages = with pkgs; [
    # Remote desktop
    parsec-bin

    # UML
    libsForQt5.umbrello

    ## Development
    (python3.withPackages (
      ps: with ps; [
        beautifulsoup4
        matplotlib
        numpy
        pycodestyle
        sympy
        requests
        tkinter
      ]
    ))
    gcc
    # texlive.combined.scheme-basic
    texlive.combined.scheme-full
  ];

  myModules = {
    programs = {
      office = {
        enable = true;
        spellCheck.enable = true;
      };
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          ms-python.python
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          james-yu.latex-workshop
        ];
      };
    };
    nixvim.languages = {
      python = true;
      markdown = true;
      tex = true;
    };
  };
}
