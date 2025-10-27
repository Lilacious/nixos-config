{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Yuchen He";
      user.email = "yuchenhe126@gmail.com";
      aliases = {
        ci = "commit -s";
        co = "checkout";
        br = "branch";
        st = "status";
        df = "diff";
        dc = "diff --cached";
        lol = "log --graph --decorate
          --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate
          --pretty=oneline --abbrev-commit --all";
        lolb = "log --graph --decorate
          --pretty=format:'%Cred%h%Creset
          -%C(yellow)%d%Creset %s %Cgreen(%cr)
          %C(bold blue)<%an>%Creset'
          --abbrev-commit --all
          --simplify-by-decoration";
        hist = "log --pretty=format:\"%h %ad|%s%d
          [%an]\" --graph --date=short";
      };
    };
    ignores = [
      #"*.test"
    ];
  };
}
