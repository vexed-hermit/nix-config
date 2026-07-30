{ config, pkgs, inputs, ... }:

{
  home.username = "doctor";
  home.homeDirectory = "/home/doctor";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    btop
    bat
    wl-clipboard
    curl
    fastfetch
    tree
  ];

  home.file = {
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      user.name = "kingro27";
      user.email = "kumarvasu2006@gmail.com";
    };
  };

  home.sessionVariables = {
    EDITOR = "nano";
  };

  programs.home-manager.enable = true;
}
