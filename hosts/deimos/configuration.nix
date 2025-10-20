{
  # Fix VSCode WSL
  programs.nix-ld.enable = true;

  myModules.nixvim.languages = {
    java = true;
  };
}
