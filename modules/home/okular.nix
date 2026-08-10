{ lib, config, inputs, ... }:
let
  cfg = config.custom.okular;
in
{
  options.custom.okular.enable = lib.mkEnableOption "Okular PDF viewer config";

  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  config = lib.mkIf cfg.enable {
    programs.okular = {
      enable = true;
      package = null;

      general = {
        smoothScrolling = true;
        showScrollbars = true;
        openFileInTabs = true;
        viewContinuous = true;
        viewMode = "Single";
        zoomMode = "fitWidth";
        mouseMode = "TextSelect";
        obeyDrm = true;
      };

      accessibility = {
        highlightLinks = true;
        changeColors = {
          enable = true;
          mode = "Inverted";
        };
      };

      performance = {
        enableTransparencyEffects = true;
        memoryUsage = "Normal";
      };
    };
  };
}
