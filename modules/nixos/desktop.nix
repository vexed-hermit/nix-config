{ lib, config, ... }:
let
  cfg = config.custom.desktop;
  des = config.hostSettings.desktopEnvironments;
  dm = config.hostSettings.displayManager;
in
{
  options.custom.desktop.enable = lib.mkEnableOption "graphical desktop";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.xserver.enable = true;
      services.xserver.xkb = { layout = "us"; variant = ""; };
    }

    (lib.mkIf (builtins.elem "plasma6" des) { services.desktopManager.plasma6.enable = true; })
    (lib.mkIf (builtins.elem "gnome" des) { services.desktopManager.gnome.enable = true; })
    (lib.mkIf (builtins.elem "cosmic" des) { services.desktopManager.cosmic.enable = true; })

    (lib.mkIf (dm == "sddm") { services.displayManager.sddm.enable = true; })
    (lib.mkIf (dm == "gdm") { services.displayManager.gdm.enable = true; })
    (lib.mkIf (dm == "cosmic-greeter") { services.displayManager.cosmic-greeter.enable = true; })
  ]);
}
