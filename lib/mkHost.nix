{
  nixpkgs,
  home-manager,
  inputs,
  username ? "doctor",
}:

{
  hostname,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs hostname; };
  modules = [
    ../hosts/${hostname}
    home-manager.nixosModules.home-manager
    {
      networking.hostName = hostname;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit inputs; };
        users.${username} = import ../users/${username};
      };
    }
  ]
  ++ extraModules;
}
