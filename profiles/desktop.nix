{
  config,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./nixos.nix
    ../modules/desktop
    ../modules/other
    ../modules/programs

    ../users/yunix/full.nix
  ];

  programs.ssh = {
    # gnome-keyring brings its own agent, both cannot be enabled
    startAgent = mkDefault (!config.services.gnome.gcr-ssh-agent.enable);
    extraConfig = ''
      AddKeysToAgent 4h
    '';
  };
}
