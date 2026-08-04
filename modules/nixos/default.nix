{ ... }:

{
  imports = [
    ./nix-settings.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./desktop.nix
    ./audio.nix
    ./bluetooth.nix
    ./printing.nix
    ./programs.nix
    ./browsers.nix
    ./flatpak.nix
    ./syncthing.nix
    ./ssh.nix
    ./sops-nix.nix
    ./stylix.nix
  ];
}
