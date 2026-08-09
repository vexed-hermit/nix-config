{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    profiles.default.presets.betterfox.enable = true;

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
  };
}
