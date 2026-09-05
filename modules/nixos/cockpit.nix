{ lib, config, ... }:

let
  cfg = config.custom.cockpit;
in
{
  options.custom.cockpit.enable = lib.mkEnableOption "Cockpit web-based server administration UI";

  config = lib.mkIf cfg.enable {
    services.cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
        };
      };
    };

    systemd.sockets.cockpit.wantedBy = [ "sockets.target" ];

    networking.firewall.allowedTCPPorts = [ 9090 ];
  };
}
