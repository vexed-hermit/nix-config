{ lib, config, pkgs, ... }:

let
  cfg = config.custom.desktopTheming;
in
{
  options.custom.desktopTheming.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.enable;
    description = "System-wide theming via stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    stylix.polarity = "dark";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };
}
