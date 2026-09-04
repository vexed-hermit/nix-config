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
    libGLU

    # X11 stack
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libXtst
    libXmu
    libXt

    # Wayland stack
    wayland
    libxkbcommon

    alsa-lib
    libpulseaudio
  ];

  nixpkgs.config.allowUnfree = true;
}
