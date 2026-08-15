{ lib, ... }:
{
  options.hostSettings.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "Primary interactive user on this host (used by modules that need a home directory, e.g. syncthing, nh).";
  };

  options.hostSettings.desktopEnvironments = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [ "plasma6" "gnome" "cosmic" "niri" ]);
    default = [ "plasma6" ];
    description = "Desktop session(s) to install on this host. Multiple entries show up as separate session choices at the login screen.";
  };

  options.hostSettings.displayManager = lib.mkOption {
    type = lib.types.enum [ "sddm" "gdm" "cosmic-greeter" ];
    default = "sddm";
    description = "Display manager (greeter) for this host — independent of which desktop sessions are installed.";
  };
}
