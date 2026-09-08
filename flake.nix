{
  description = "doctor's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helium-browser.url = "github:oxcl/nix-flake-helium-browser";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      myLib = import ./lib { inherit inputs nixpkgs; };
    in

    {
      nixosConfigurations = {
        tardis = myLib.mkHost {
          hostname = "tardis";
          system = "x86_64-linux";
          users = [ "doctor" "guest" ];
        };
      };

      # Standalone home-manager configs for non-NixOS systems (e.g. Arch).
      # Activate with: home-manager switch --flake .#doctor@arch
      homeConfigurations = {
        "doctor@arch" = myLib.mkHome {
          user = "doctor";
          system = "x86_64-linux";
        };
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
