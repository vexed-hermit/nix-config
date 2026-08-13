{ lib, config, pkgs, ... }: # Added 'pkgs' here in case you want to explicitly define the package

let
  cfg = config.custom.syncthing;
  obsidianEnabled = config.custom.obsidian.enable or false;
in
{
  options.custom.syncthing.enable = lib.mkEnableOption "Syncthing config";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      overrideFolders = true;
      overrideDevices = true;

      # Optional: You can omit this line as it is the default,
      # but if you keep it, ensure there are no quotes around it.
      package = pkgs.syncthing;

      settings = {
        devices.phone = {
          id = "6XTPSIU-NQALQUC-VVSALKR-N7CJ647-VHMAG5E-CGTI3KS-PZ45737-4HYSHQR";
          name = "phone";
        };

        folders = {
          "Documents" = {
            id = "documents";
            # Fixed the path variable
            path = "${config.home.homeDirectory}/Documents";
            devices = [ "phone" ];
          };
          "Music" = {
            id = "music";
            path = "${config.home.homeDirectory}/Music";
            devices = [ "phone" ];
          };
        } // lib.optionalAttrs obsidianEnabled {
          "obsidian" = {
            id = "obsidian";
            path = "${config.home.homeDirectory}/Obsidian";
            devices = [ "phone" ];
          };
        }; # Added the missing closing brace and semicolon here
      };
    };
  };
}
