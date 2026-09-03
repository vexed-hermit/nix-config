{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    glib
    libGL

    # X11 stack
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libXtst

    # Wayland stack
    wayland
    libxkbcommon

    alsa-lib
    libpulseaudio
  ];

  nixpkgs.config.allowUnfree = true;
}
