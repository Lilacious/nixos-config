{
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./desktop.nix
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
