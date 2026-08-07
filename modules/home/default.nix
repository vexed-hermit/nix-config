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
    ./yt-dlp.nix
    ./zed-editor.nix
    ./tmux.nix
    ./ghostty.nix
  ];

  programs.home-manager.enable = true;
}
