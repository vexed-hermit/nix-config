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
    # rclone CLI comes with the module so the toggle owns the package too
    home.packages = [ pkgs.rclone ];

    systemd.user.services.rclone-gdrive = {
      Unit = {
        Description = "Mount Google Drive via rclone";
      };

      Service = {
        Type = "simple";
        Environment = [ "PATH=/run/wrappers/bin" ]; # so rclone can find fusermount
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";
        ExecStart = "${pkgs.rclone}/bin/rclone mount \"gdrive:My Folder/Sub Folder\" %h/GoogleDrive --vfs-cache-mode full";
        ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
