{
  lib,
  ...
}:

{
  imports = (import ../../lib/scanPaths.nix { inherit lib; }) ./.;

  programs.home-manager.enable = true;
}
