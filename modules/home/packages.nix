{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    wl-clipboard
    curl
    fastfetch
    tree
    unzip
    zip
  ];

  home.sessionVariables = {
    EZA_ICON_SPACING = "2";
  };
}
