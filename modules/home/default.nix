{ ... }:

{
  imports = [
    ./packages.nix
    ./bash.nix
    ./shell-tools.nix
    ./git.nix
    ./browser.nix
    ./flatpak.nix
    ./services.nix
  ];

  programs.home-manager.enable = true;
}
