{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.myHome.programs.bash;
in
{
  options = {
    myHome.programs.bash = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignoreboth"
      ];
      historyFile = "${config.xdg.configHome}/bash/bash_history";
      historyFileSize = 500000;
    };
  };
}
