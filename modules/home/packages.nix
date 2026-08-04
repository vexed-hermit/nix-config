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
    EDITOR = "zeditor --wait";
    VISUAL = "zeditor --wait";
    EZA_ICON_SPACING = "2";
    LESS = "-R --use-color -Dd+r$Du+b$";
  };
}
