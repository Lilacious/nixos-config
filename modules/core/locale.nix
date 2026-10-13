{
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.core;
in
{
  # nix-darwin has no i18n nor console options
  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (options ? i18n) {
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

      ## en_IE: English text with de_DE-like formats (24h time, metric, A4, EUR)
      ## Don't set LC_ALL, it overrides LANG and every other category
      i18n.extraLocaleSettings = genAttrs [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ] (_: "en_IE.UTF-8");
    })

    (optionalAttrs (options ? console) {
      ## Default keymap (standard German keyboard)
      console.keyMap = mkDefault "de";
    })
  ]);
}
