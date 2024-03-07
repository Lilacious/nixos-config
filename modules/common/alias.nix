{ variables, ... }:
{
  home-manager.users.${variables.username} = {
    home.shellAliases = {
      ls = "eza";
      ll = "eza -lgS";
      la = "eza -a";
      tree = "eza -T";
      c = "clear";
      cat = "bat";
      update = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#$HOST";
    };
  };
}
