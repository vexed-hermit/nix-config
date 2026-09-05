{ lib, hostMeta, ... }:
{
  imports = [
    ../../modules/nixos
  ] ++ (import ../../lib/scanPaths.nix { inherit lib; } ./.);

  custom.desktop.enable = true;   # pulls in bluetooth, printing, flatpak, browser policies, theming via their defaults
  custom.syncthing.enable = true;
  custom.virtualisation.enable = true;
  custom.podman.enable = true;
  custom.marinara.enable = true;
  custom.sillytavern.enable = true;
  custom.cockpit.enable = true;
  custom.powerManagement.enable = true;   # TLP-based battery tuning; see modules/nixos/power-management.nix
  hostSettings.primaryUser = hostMeta.primaryUser;
  hostSettings.desktopEnvironments = hostMeta.desktopEnvironments;
  hostSettings.displayManager = hostMeta.displayManager;

  time.timeZone = "Asia/Kathmandu";

  # Leave this as the release you first installed with; see NixOS docs on stateVersion.
  system.stateVersion = "26.05";
}
