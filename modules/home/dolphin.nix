{ lib, config, ... }:
let
  cfg = config.custom.dolphin;
in
{
  options.custom.dolphin.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.plasma.enable;
    description = "Dolphin config";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma.configFile.dolphinrc = {
      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };
    };
  };
}
