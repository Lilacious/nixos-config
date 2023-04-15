{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {

      add_newline = false;

      line_break.disabled = false;

      right_format = "$status";

      username = {
        show_always = false;
        format = ''[$user]($style)'';
        disabled = false;
      };

      character = {
        format = "$symbol";
        success_symbol = "[ ❯ ](bold green)";
        error_symbol = "[ ❮ ](bold red)";
        vicmd_symbol = "[ ❯ ](bold yellow)";
      };

      directory = {
        format = "[$read_only]($read_only_style)[ $path]($style) ";
        read_only = " ";
        truncation_length = 3;
        truncation_symbol = "../";
      };

      git_branch = {
        symbol = "  ";
        format = ''[$symbol$branch]($style)'';
        style = "bold green";
      };

      git_status = {
        format = "[$conflicted$stashed$deleted$renamed$staged$modified$untracked$ahead_behind ]($style)";
        conflicted = " =($count)";
        ahead = " ⇡($count)";
        behind = " ⇣($count)";
        diverged = " ⇕⇡($ahead_count)⇣($behind_count)";
        untracked = " ?($count)";
        stashed = " $($count)";
        modified = " !($count)";
        staged = " +($count)";
        renamed = " »($count)";
        deleted = " ✘($count)";
        style = "bold yellow";
      };

      hostname = {
        format = "@[$hostname]($style)";
        ssh_only = true;
      };

      status = {
        disabled = false;
      };
     
    };
  };
}
