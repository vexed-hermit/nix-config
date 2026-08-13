{ lib, config, ... }:

let
  cfg = config.custom.vesktop;
in
{
  options.custom.vesktop.enable = lib.mkEnableOption "Vesktop (Discord client with Vencord built-in)";

  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
      settings = {
        minimizeToTray = true;
        discordBranch = "stable";
      };
      vencord.settings = {
        plugins = {
          SilentTyping.enable = true;
        };
      };
    };
  };
}
