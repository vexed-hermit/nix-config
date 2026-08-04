{
  description = "doctor's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser.url = "github:oxcl/nix-flake-helium-browser";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      helium-browser,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHost = import ./lib/mkHost.nix {
        inherit nixpkgs home-manager inputs;
      };
    in

    {
      nixosConfigurations = {
        nixos = mkHost { hostname = "nixos"; };
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
