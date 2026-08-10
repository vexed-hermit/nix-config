{ lib, config, ... }:

let
  cfg = config.custom.desktop;
in
{
  options.custom.desktop.enable = lib.mkEnableOption "graphical desktop (xserver, sddm, plasma6)";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
