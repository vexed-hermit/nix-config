{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/doctor/Projects/nix-config";
  };

  programs.kdeconnect.enable = true;

  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    zed-editor
    ghostty
  ];
}
