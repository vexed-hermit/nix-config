{ lib, config, ... }:

let
  cfg = config.custom.syncthing;
in
{
  options.custom.syncthing.enable = lib.mkEnableOption "Syncthing sync service for the primary user";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      openDefaultPorts = true;
      user = config.hostSettings.primaryUser;
      group = "users";
      dataDir = "/home/${config.hostSettings.primaryUser}";
      configDir = "/home/${config.hostSettings.primaryUser}/.config/syncthing";
    };
  };
}
