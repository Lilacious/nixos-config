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
    moonlight-qt

    # UML
    #libsForQt5.umbrello

    ## Development
    (python3.withPackages (
      ps: with ps; [
        matplotlib
        numpy
        pycodestyle
        sympy
        requests
        tkinter
        #beautifulsoup4

        ## jupyter notebook
        #scipy
        #jupyterlab
        #pandas
        #statsmodels
        #scikitlearn
        #seaborn
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
      c = true;
      python = true;
      rust = true;
      markdown = true;
      tex = true;
      haskell = true;
    };
  };
}
