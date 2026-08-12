{ lib, config, pkgs, ... }:
let
  cfg = config.custom.discord;
in
{
  options.custom.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf cfg.enable {
    # Install Discord
    home.packages = [ pkgs.discord ];

    xdg.configFile."discord-flags.conf".text = ''
      --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
      --ozone-platform=wayland
    '';

    # Manage Discord's settings.json declaratively
    xdg.configFile."discord/settings.json".text = builtins.toJSON {
      SKIP_HOST_UPDATE = true;
      IS_MAXIMIZED = true;
      IS_MINIMIZED = false;
      WINDOW_BOUNDS = {
        x = 0;
        y = 0;
        width = 1280;
        height = 800;
      };
      openasar = {
        quickstart = true;
        firstRun = false;
      };
    };
  };
}
