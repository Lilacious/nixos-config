{ pkgs, anyrun, ... }:

let 
  pluginpkgs = "anyrun.packages.${pkgs.system}";
in {
  imports = [
    anyrun.homeManagerModules.default
  ];

  home.sessionVariables = {
    ANYRUNAPPLICATIONS="${anyrun.packages.${pkgs.system}.applications}/lib/libapplications.so";
    ANYRUNSHELL="${anyrun.packages.${pkgs.system}.shell}/lib/libshell.so";
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with anyrun.packages.${pkgs.system}; [
        applications
        randr
        shell
        symbols
      ];

      width.fraction = 0.25;
      y.absolute = 20;
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 10;
    };
    extraCss = ''
      @define-color bg-col  rgba(30, 30, 46, 0.7);
      @define-color bg-col-light rgba(150, 220, 235, 0.7);
      @define-color border-col rgba(30, 30, 46, 0.7);
      @define-color selected-col rgba(150, 205, 251, 0.7);
      @define-color fg-col #D9E0EE;
      @define-color fg-col2 #F28FAD;

      * {
        transition: 200ms ease;
        font-family: "Agave Nerd Font";
        font-size: 1rem;
      }

      entry {
        color: @fg-col;
        background-color: @bg-col;
      }

      window {
        background: transparent;
      }

      #main, #plugin {
        border: 3px solid @border-col;
        color: @fg-col;
        background-color: @bg-col;
      }

      #match {
        color: @fg-col;
        background: @bg-col;
      }

      #match:selected {
        color: @fg-col2;
        background: @selected-col;
      }

      #match {
        padding: 3px;
        border-radius: 16px;
      }

      #entry, #plugin:hover {
        border-radius: 16px;
      }

      box#main {
        background: rgba(30, 30, 46, 0.7);
        border: 1px solid @border-col;
        border-radius: 15px;
        padding: 5px;
      }
    '';
  };
}
