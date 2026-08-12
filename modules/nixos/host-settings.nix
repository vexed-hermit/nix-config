{
  lib,
  ...
}:
{
  options.hostSettings.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "Primary interactive user on this host (used by modules that need a home directory, e.g. syncthing, nh).";
  };

  options.hostSettings.desktopEnvironment = lib.mkOption {
    type = lib.types.enum [ "plasma6" "gnome" "cosmic" ];
    default = "plasma6";
    description = "Desktop environment + display manager for this host.";
  };
}
