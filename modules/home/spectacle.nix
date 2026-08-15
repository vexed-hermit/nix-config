{ lib, config, ... }:
let
  cfg = config.custom.spectacle;
in
{
  options.custom.spectacle.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.plasma.enable;
    description = "spectacle config";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma.configFile.spectaclerc = {
      ImageSave.translatedScreenshotsFolder = "Screenshots";
      VideoSave.translatedScreencastsFolder = "Screencasts";
    };
  };
}
