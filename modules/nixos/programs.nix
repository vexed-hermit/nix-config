{ pkgs, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/doctor/Projects/nix-config";
  };

  programs.neovim.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
