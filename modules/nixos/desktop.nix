{ lib, config, ... }:
let
  cfg = config.custom.desktop;
  de = config.hostSettings.desktopEnvironment;
in
{
  options.custom.desktop.enable = lib.mkEnableOption "graphical desktop";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.xserver.enable = true;
      services.xserver.xkb = { layout = "us"; variant = ""; };
    }
    (lib.mkIf (de == "plasma6") {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
    })
    (lib.mkIf (de == "gnome") {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
    })
    (lib.mkIf (de == "cosmic") {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
    })
  ]);
}
