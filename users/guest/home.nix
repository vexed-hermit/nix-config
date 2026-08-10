{
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.helium-browser.homeModules.default

    ../../modules/home
  ];

  home.username = "guest";
  home.homeDirectory = "/home/guest";
  home.stateVersion = "26.05";
}
