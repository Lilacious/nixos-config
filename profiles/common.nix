{ lib, inputs, outputs, ... }: {
  imports = [
    ../modules/nixos/common
  ];

  nixpkgs.config.allowUnfree = true;

  # for programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  # enable zsh system-wide
  programs.zsh.enable = true;
}
