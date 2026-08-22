{
  inputs,
  nixpkgs,
  ...
}:
{
  mkHost = import ./mkHost.nix { inherit inputs nixpkgs; };
  mkHome = import ./mkHome.nix { inherit inputs nixpkgs; };
  scanPaths = import ./scanPaths.nix;
}
