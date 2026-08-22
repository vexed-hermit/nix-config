{ nixpkgs, inputs, ... }:
{
  user,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:

inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};
  extraSpecialArgs = { inherit inputs; };
  modules = [
    ../users/${user}/home.nix
  ] ++ extraModules;
}
