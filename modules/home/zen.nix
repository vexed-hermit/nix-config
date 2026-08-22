{ lib, config, inputs, ... }:

let
  cfg = config.custom.zenBrowser;
in
{
  options.custom.zenBrowser.enable = lib.mkEnableOption "Zen browser with personal profile/pins";

  imports = [ inputs.zen-browser.homeModules.twilight ];

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      profiles.default.presets.betterfox.enable = true;

      policies =
        let
          mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          });
        in
        {
          ExtensionSettings = mkExtensionSettings {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
            "uBlock0@raymondhill.net" = "ublock-origin";
            "sponsorBlocker@ajay.app" = "sponsorblock";
          };
        };

      profiles.default = {
        pinsForce = true;
        pinsForceAction = "remove";
        pins = {
          "YouTube" = {
            id = "a77145fa-8d77-40ed-b94b-63b3a2ada907";
            url = "https://youtube.com";
            position = 100;
            isEssential = true;
          };
          "Gemini" = {
            id = "85f54438-58c2-4524-9adc-4c02b6fd57bd";
            url = "https://gemini.google.com";
            position = 200;
            isEssential = true;
          };
          "Claude" = {
            id = "ebf62078-852d-481f-8fa3-7eb21f82a351";
            url = "https://claude.ai";
            position = 300;
            isEssential = true;
          };
          "Reddit" = {
            id = "e49da172-b97c-4f7c-a35c-8df4fa155d1d";
            url = "https://reddit.com";
            position = 400;
            isEssential = true;
          };
          "Comick" = {
            id = "7991390c-e4c6-464b-8463-b72a64eb392e";
            url = "https://comick.io";
            position = 500;
            isEssential = true;
          };
          "Whatsapp" = {
            id = "86e2ac39-d846-4b7b-9fc7-a0dde88a23ac";
            url = "https://web.whatsapp.com";
            position = 600;
            isEssential = true;
          };
        };

        settings = {
          "browser.tabs.unloadOnLowMemory" = true;
          "browser.tabs.min_inactive_duration_before_unload" = 600000; # 10 min, in ms
          "browser.low_commit_space_threshold_percent" = 100;          # be more aggressive about "low memory"
        };
      };
    };
  };
}
