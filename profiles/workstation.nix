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
    #parsec-bin
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
    #texlive.combined.scheme-full
  ];

  myModules = {
    programs = {
      office = {
        enable = true;
        spellCheck.enable = true;
      };
      vscode = {
        enable = true;
        extensions =
          with pkgs.vscode-extensions;
          [
            ms-python.python
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            james-yu.latex-workshop
          ]
          ++ [
            # Luau (noctalia plugins), not packaged in nixpkgs
            (pkgs.vscode-utils.extensionFromVscodeMarketplace {
              publisher = "JohnnyMorganz";
              name = "luau-lsp";
              version = "1.70.1";
              hash = "sha256-3ZDnzTz7ceBUdxwPbi8En0IpWsoIh58I8FYY5u7yBjc=";
            })
          ];
        userSettings = {
          # the extension's bundled server is a prebuilt binary that doesn't run on NixOS
          "luau-lsp.server.path" = getExe pkgs.luau-lsp;
          # plain Luau, not Roblox: no Roblox types or Rojo sourcemaps
          "luau-lsp.platform.type" = "standard";
          "luau-lsp.types.roblox" = false;
          "luau-lsp.sourcemap.enabled" = false;
          # noctalia's plugin API (ui, noctalia, panel, barWidget) for the menubar plugin
          "luau-lsp.types.definitionFiles" = {
            noctalia = "${../pkgs/noctalia-menubar/noctalia.d.luau}";
          };
        };
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
