{ ... }:

{
  # Only the settings that differ from btop's stock defaults.
  # Everything else in btop.conf is left at default.
  programs.btop = {
    enable = true;

    settings = {
      # Default: "Default" -> custom theme file expected at
      # ~/.config/btop/themes/current.theme

      # Default: false -> enables h/j/k/l/g/G navigation
      vim_keys = true;
    };
  };
}
