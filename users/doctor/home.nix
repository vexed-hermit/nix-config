{ inputs, ... }:
{
  imports = [
    inputs.helium-browser.homeModules.default
    ../../modules/home
  ];

  home.username = "doctor";
  home.homeDirectory = "/home/doctor";
  home.stateVersion = "26.05";

  custom.gitIdentity.enable = true;
  custom.heliumBrowser.enable = true;
  custom.zenBrowser.enable = true;
  custom.kdePlasma.enable = true;
  custom.zedEditor.enable = true;
  custom.okular.enable = true;
  custom.ytDlp.enable = true;
  custom.basePackages.enable = true;
  custom.mediaServices.enable = true;
  custom.vesktop.enable = true;
  custom.obsidian.enable = true;

  services.flatpak.packages = [
    "com.stremio.Stremio"
  ];
}
