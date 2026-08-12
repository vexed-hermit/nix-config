{
  ...
}:

{
  imports = [
    ../../modules/nixos
  ] ++ (import ../../lib/scanPaths.nix { inherit lib; } ./.);

  custom.desktop.enable = true;   # pulls in bluetooth, printing, flatpak, browser policies, theming via their defaults
  custom.syncthing.enable = true;
  hostSettings.primaryUser = "doctor";
  hostSettings.desktopEnvironment = "plasma6";

  time.timeZone = "Asia/Kathmandu";

  # Leave this as the release you first installed with; see NixOS docs on stateVersion.
  system.stateVersion = "26.05";
}
