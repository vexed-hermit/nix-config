{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.custom.rcloneGdrive;
in
{
  options.custom.rcloneGdrive.enable = lib.mkEnableOption "Google Drive rclone mount at ~/GoogleDrive";

  config = lib.mkIf cfg.enable {
    systemd.user.services.rclone-gdrive = {
      description = "Mount Google Drive via rclone";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];

      # fusermount wrapper needed for ExecStop and by rclone itself
      path = [ "/run/wrappers/bin" ];

      serviceConfig = {
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p %h/GoogleDrive";
        ExecStart = "${pkgs.rclone}/bin/rclone mount \"gdrive:My Folder/Sub Folder\" %h/GoogleDrive --vfs-cache-mode full";
        ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
