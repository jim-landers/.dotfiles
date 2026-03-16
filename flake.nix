{
  description = "NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      neovim-nightly-overlay,
      home-manager,
      nixos-wsl,
      wrappers,
    }:
    let
      unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      neovim-nightly = neovim-nightly-overlay.packages.x86_64-linux.neovim;
      sharedModules = [
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          nixpkgs.config.allowUnfree = true;
        }
      ];
      username = "land";
    in
    {
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
              home-manager.extraSpecialArgs = { inherit username wrappers neovim-nightly; };
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
              home-manager.extraSpecialArgs = {
                inherit
                  username
                  self
                  unstable
                  wrappers
                  neovim-nightly
                  ;
              };
            }
          ];
        };
      };
    };
}
