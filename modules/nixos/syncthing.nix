{ lib, config, ... }:

let
  cfg = config.custom.syncthing;
  user = config.hostSettings.primaryUser;
in
{
  options.custom.syncthing.enable = lib.mkEnableOption "Syncthing sync service for the primary user";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      inherit user;
      dataDir = "/home/${user}";
      configDir = "/home/${user}/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        devices.phone.id = "6XTPSIU-NQALQUC-VVSALKR-N7CJ647-VHMAG5E-CGTI3KS-PZ45737-4HYSHQR";
        folders = {
          "Documents" = {
            id = "documents";
            path = "/home/${user}/Documents";
            devices = [ "phone" ];
          };
          "Music" = {
            id = "music";
            path = "/home/${user}/Music";
            devices = [ "phone" ];
          };
        };
      };
    };
  };
}
