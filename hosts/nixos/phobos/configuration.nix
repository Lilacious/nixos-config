{ pkgs, ... }:
{
  myModules = {
    nixvim.languages.java = true;
    programs.sshAgent.enable = true;
  };

  environment.systemPackages = [
    pkgs.texliveFull
  ];
}
