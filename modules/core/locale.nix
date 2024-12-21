{ lib, options, ... }:
with lib;
{
  # nix-darwin has no i18n nor console options
  config = mkMerge [
    (
      if (builtins.hasAttr "i18n" options) then
        {
          i18n.supportedLocales = [
            "en_IE.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
            "de_DE.UTF-8/UTF-8"
            "ja_JP.UTF-8/UTF-8"
            "zh_CN.UTF-8/UTF-8"
            "zh_TW.UTF-8/UTF-8"
            "ko_KR.UTF-8/UTF-8"
          ];

          i18n.defaultLocale = "en_US.UTF-8";

          i18n.extraLocaleSettings = {
            ## en_IE: English but de_DE like locale
            LC_ALL = "en_IE.UTF-8";

            #LC_ADDRESS = "de_DE.UTF-8";
            #LC_IDENTIFICATION = "de_DE.UTF-8";
            #LC_MEASUREMENT = "de_DE.UTF-8";
            #LC_MONETARY = "de_DE.UTF-8";
            #LC_NAME = "de_DE.UTF-8";
            #LC_NUMERIC = "de_DE.UTF-8";
            #LC_PAPER = "de_DE.UTF-8";
            #LC_TELEPHONE = "de_DE.UTF-8";
            #LC_TIME = "de_DE.UTF-8";
          };
        }
      else
        { }
    )

    (
      if (builtins.hasAttr "console" options) then
        {
          ## Default keymap (standard German keyboard)
          console.keyMap = mkDefault "de";
        }
      else
        { }
    )
  ];
}
