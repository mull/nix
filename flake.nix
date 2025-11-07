{
  description = "mull's nixos setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    mkHost = { system, hostPath, username }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/common.nix
          ./modules/networking.nix
          ./modules/users.nix
          ./modules/desktop.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mull = import ./home.nix;
          }
          hostPath # host specific config, i.e. hosts/$hostPath/hardware-configuration.nix etc
        ];
      };
  in {
    nixosConfigurations.vm = mkHost {
      system = "aarch64-linux";
      hostPath = ./hosts/vm/configuration.nix;
      username = "mull";
    };
   
  };
}
