{ lib, config, ... }:
let
  cfg = config.custom.kate;
in
{
  options.custom.kate.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.plasma.enable;
    description = "Kate editor behavioral settings";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma.configFile.katerc = {
      General = {
        "Show Full Path in Title" = false;
        "Show Menu Bar" = true;
        "Show Status Bar" = true;
        "Show Tab Bar" = true;
        "Show Url Nav Bar" = true;
      };
      "KTextEditor Renderer" = {
        "Animate Bracket Matching" = false;
        "Auto Color Theme Selection" = true;
        "Line Height Multiplier" = 1;
        "Show Indentation Lines" = false;
        "Show Whole Bracket Expression" = false;
        "Word Wrap Marker" = false;
      };
    };
  };
}
