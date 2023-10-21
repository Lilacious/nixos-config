{ lib, inputs, outputs, ... }: {
  imports = [
    ../modules/nixos/common
  ];

  # for programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  # enable zsh system-wide
  programs.zsh.enable = true;
}
