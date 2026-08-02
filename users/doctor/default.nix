{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.helium-browser.homeModules.default

    ../../modules/home
  ];

  home.username = "doctor";
  home.homeDirectory = "/home/doctor";
  home.stateVersion = "26.05";
}
