{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myModules.programs.tudTools;
in {
  options = {
    myModules.programs.tudTools = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      ## Digitaltechnik
      verilog
      gtkwave
      yosys
      graphviz
    ];
  };
}
