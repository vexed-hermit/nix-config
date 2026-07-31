{ config, pkgs, inputs, ... }:

{
  home.username = "doctor";
  home.homeDirectory = "/home/doctor";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    btop
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

  programs.ripgrep-all.enable = true;

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    fzf.enable = true;
    keyScheme = "vim";
  };

  programs.bat.enable = true;

  services.playerctld.enable = true;

  home.sessionVariables = {
    EDITOR = "nano";
  };

  programs.home-manager.enable = true;
}
