{ pkgs, ... }:
{
  nix.package = pkgs.lix;

  system.stateVersion = 5;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  fonts.packages = [
    pkgs.nerd-fonts.agave
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  # Install packages
  homebrew = {
    enable = true;
    onActivation = {
      # zap uninstalls all formulae/files not listed in the generated Brewfile
      cleanup = "zap";
      # Fetch the newest stable branch of Homebrew's git repo
      autoUpdate = true;
      # Upgrade outdated applications
      upgrade = true;
      extraFlags = [
        #"--verbose"
      ];
    };

    brews = [
    ];

    casks = [
      "firefox"
      "alacritty"
      "keepassxc"
      "notion"
    ];

    taps = [
    ];
  };

  system.defaults = {
    dock = {
      autohide = false;
      show-recents = false; # disable recent apps
    };

    finder = {
      _FXShowPosixPathInTitle = false;
      AppleShowAllExtensions = true; # show all file extensions
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      NewWindowTarget = "Home";
      QuitMenuItem = true; # allow quitting finder
    };

    trackpad = {
      Clicking = true; # enable tap to click
      TrackpadRightClick = true; # enable two finger right click
      TrackpadThreeFingerDrag = true; # enable three finger drag
    };
    NSGlobalDomain.AppleFontSmoothing = 0;
    loginwindow = {
      GuestEnabled = false;
    };
  };
}
