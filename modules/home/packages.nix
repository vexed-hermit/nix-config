{ lib, pkgs, config, ... }:

let
  cfg = config.custom.basePackages;
in
{
  options.custom.basePackages.enable = lib.mkEnableOption "baseline CLI packages for this user";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      curl
      fastfetch
      tree
      unzip
      zip
      poppler-utils
      imagemagick
      vlc
    ];

    home.sessionVariables = {
      EZA_ICON_SPACING = "2";
    };
  };
}
