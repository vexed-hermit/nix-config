{ lib, config, ... }:

let
  cfg = config.custom.syncthing;
in
{
  options.custom.syncthing.enable = lib.mkEnableOption "Syncthing sync service for the primary user";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      openDefaultPorts = true;
    };
  };
}
