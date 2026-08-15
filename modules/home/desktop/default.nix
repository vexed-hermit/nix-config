{ lib, hostMeta, ... }:
{
  imports = (import ../../../lib/scanPaths.nix { inherit lib; }) ./.;

  custom.desktop.plasma.enable = lib.mkDefault (builtins.elem "plasma6" hostMeta.desktopEnvironments);
  custom.desktop.cosmic.enable = lib.mkDefault (builtins.elem "cosmic" hostMeta.desktopEnvironments);
}
