{ lib, variables, pkgs, ... }:

with lib;
{
  home-manager.users.${variables.username} = {
    programs.tmux = {
      enable = mkDefault true;
      clock24 = true;
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
      ];
      extraConfig = ''
        ## https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"
        
        ## Activate better mouse mode
        set-option -g mouse on
      '';
    };
  };
}
