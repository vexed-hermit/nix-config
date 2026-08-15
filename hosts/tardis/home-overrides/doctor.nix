{ ... }:
{
  programs.plasma.configFile = {
    kcminputrc = {
      "Libinput/1739/52967/SYNA32EB:00 06CB:CEE7 Touchpad" = {
        ClickMethod = 2;
        NaturalScroll = true;
      };
      Mouse.X11LibInputXAccelProfileFlat = true;
    };
    kwinrc.Xwayland.Scale = 1.3;
  };
}
