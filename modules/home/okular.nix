{ pkgs, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.okular = {
    enable = true;
    package = null;

    general = {
      smoothScrolling = true;
      showScrollbars = true;
      openFileInTabs = true;
      viewContinuous = true;
      viewMode = "Single";
      zoomMode = "fitWidth";
      mouseMode = "TextSelect";
      obeyDrm = true;
    };

    accessibility = {
      highlightLinks = true;
      changeColors = {
        enable = true;
        mode = "Inverted";
      };
    };

    performance = {
      enableTransparencyEffects = true;
      memoryUsage = "Normal";
    };
  };
}
