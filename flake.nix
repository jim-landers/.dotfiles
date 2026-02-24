{
  description = "NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-wsl }:
    let
      sharedModules = [
          { nixpkgs.config.allowUnfree = true; }
      ];
      username = "land";
    in {
      nixosConfigurations = {
        homelab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [
            ./hosts/homelab/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit username; };
            }
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = sharedModules ++ [
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
            home-manager.nixosModules.home-manager
            {
              wsl.enable = true;
              wsl.defaultUser = username;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit username self; };
            }
          ];
        };
      };
    };
}
