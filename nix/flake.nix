{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      hosts = [ "xos" ];
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (
        name:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${name}.nix
            home-manager.nixosModules.home-manager
          ];
        }
      );
    };
}
