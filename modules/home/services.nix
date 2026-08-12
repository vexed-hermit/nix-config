{ lib, config, ... }:

let
  cfg = config.custom.mediaServices;
in
{
  options.custom.mediaServices.enable = lib.mkEnableOption "media control background services (playerctld)";

  config = lib.mkIf cfg.enable {
    services.playerctld.enable = true;
  };
}
