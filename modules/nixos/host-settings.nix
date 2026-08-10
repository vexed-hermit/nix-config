{
  lib,
  ...
}:
{
  options.hostSettings.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "Primary interactive user on this host (used by modules that need a home directory, e.g. syncthing, nh).";
  };
}
