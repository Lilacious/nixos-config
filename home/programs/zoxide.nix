{config, ...}: {
  programs = {
    zoxide = {
      enable = true;
    };
  };
  shellAliases = {
    cd = "z"; # zoxide
    cdf = "zi"; # z with fzf
  };
}
