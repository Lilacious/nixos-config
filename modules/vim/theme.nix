{
  lib,
  options,
  config,
  ...
}:
with lib;
{
  config = mkMerge [
    {
      programs.nixvim = {
        colorschemes = {
          catppuccin = {
            enable = true;
            settings = {
              flavour = "mocha";
              term_colors = true;
            };
          };
        };
      };
    }
    (
      if (builtins.hasAttr "stylix" options) then
        {
          programs.nixvim.colorschemes.catppuccin.settings =
            let
              color = config.lib.stylix.colors.withHashtag;
            in
            {
              color_overrides.mocha = {
                base = color.base00;
                mantle = color.base01;
                text = color.base05;
                rosewater = color.base06;
                lavender = color.base07;
                red = color.base08;
                peach = color.base09;
                yellow = color.base0A;
                green = color.base0B;
                teal = color.base0C;
                blue = color.base0D;
                mauve = color.base0E;
                flamingo = color.base0F;
                crust = color.base11;
                maroon = color.base12;
                sky = color.base15;
                sapphire = color.base16;
                pink = color.base17;
              };
            };
        }
      else
        { }
    )
  ];
}
