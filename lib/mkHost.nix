{
  nixpkgs,
  home-manager,
  inputs,
  username ? "doctor",
}:

{
  hostname,
  system ? "x86_64-linux",
  users ? [ "doctor" ],
  extraModules ? [ ],
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs hostname; };
  modules = [
    ../hosts/${hostname}
    ../users/${username}/system.nix
    home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    {
      networking.hostName = hostname;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs; };
        users = nixpkgs.lib.genAttrs users (user: import ../users/${user}/home.nix);
      };
    }
  ]
  ++ (map (user: ../users/${user}/system.nix) users)
  ++ extraModules;
}
