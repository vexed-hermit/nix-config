{
  lib,
  ...
}:

{
  imports = (import ../../lib/scanPaths.nix { inherit lib; }) ./.;
}
