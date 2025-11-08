{
  description = "mull's nixos setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:
  let
    mkHost = { system, hostPath, username }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/common.nix
          ./modules/networking.nix
          ./modules/users.nix
          ./modules/shell.nix
          ./modules/desktop.nix
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
