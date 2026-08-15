{ nixpkgs, inputs, ... }:
{
  hostname,
  system ? "x86_64-linux",
  users ? [ "doctor" ],
  extraModules ? [ ],
}:

let
  hostMeta = import ../hosts/${hostname}/meta.nix;
  overridePath = user: ../hosts/${hostname}/home-overrides/${user}.nix;
  userHomeModules = user:
    [ ../users/${user}/home.nix ]
    ++ nixpkgs.lib.optional (builtins.pathExists (overridePath user)) (overridePath user);
in

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs hostname hostMeta; };
  modules = [
    ../hosts/${hostname}
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    {
      networking.hostName = hostname;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs hostname hostMeta; };
        users = nixpkgs.lib.genAttrs users (user: {
          imports = userHomeModules user;
        });
      };
    }
  ]
  ++ (map (user: ../users/${user}) users)
  ++ extraModules;
}
