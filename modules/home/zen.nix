{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    profiles.default.presets.betterfox.enable = true;

    # Extensions
    policies = let
      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      });
    in {
      ExtensionSettings = mkExtensionSettings {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "uBlock0@raymondhill.net" = "ublock-origin";
        "sponsorBlocker@ajay.app" = "sponsorblock";
      };
    };

    # Pinned tabs
    profiles.default = {
      pinsForce = true;
      pinsForceAction = "remove";

      pins = {
        "YouTube" = {
          id = "a77145fa-8d77-40ed-b94b-63b3a2ada907";
          url = "https://youtube.com";
          position = 100;
        };
        "Gemini" = {
          id = "85f54438-58c2-4524-9adc-4c02b6fd57bd";
          url = "https://gemini.google.com";
          position = 200;
        };
        "Claude" = {
          id = "ebf62078-852d-481f-8fa3-7eb21f82a351";
          url = "https://claude.ai";
          position = 300;
        };
        "Reddit" = {
          id = "e49da172-b97c-4f7c-a35c-8df4fa155d1d";
          url = "https://reddit.com";
          position = 400;
        };
        "Comick" = {
          id = "7991390c-e4c6-464b-8463-b72a64eb392e";
          url = "https://comick.io";
          position = 500;
        };
      };
    };
  };
}
