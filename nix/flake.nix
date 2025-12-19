{
  description = "NixOS configurations";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ber+6DVdnZhm2AqJvta27H8eQw=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
    }:
    let
      system = "x86_64-linux";
      hosts = [ "xos" ];
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            llm-agents = llm-agents.packages.${system};
          };
          modules = [
            ./hosts/${name}.nix
            home-manager.nixosModules.home-manager
          ];
        }
      );
    };
}
