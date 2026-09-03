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
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXext
    xorg.libXtst

    # Wayland stack
    wayland
    libxkbcommon

    alsa-lib
    libpulseaudio
  ];

  nixpkgs.config.allowUnfree = true;
}
