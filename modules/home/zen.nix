{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setDefaultBrowser = true;

    profiles.default.presets.betterfox.enable = true;
  };
}
