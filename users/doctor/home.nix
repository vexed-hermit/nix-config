{
  inputs,
  ...
}:

{
  imports = [
    inputs.helium-browser.homeModules.default
    ../../modules/home
  ];

  home.username = "doctor";
  home.homeDirectory = "/home/doctor";
  home.stateVersion = "26.05";

  services.flatpak.packages = [
    "com.stremio.Stremio"
  ];
}
