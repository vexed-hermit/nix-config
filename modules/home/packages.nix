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
    EDITOR = "nvim";
  };
}
