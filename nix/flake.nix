{
  description = "NixOS configurations";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      llm-agents,
      nixos-hardware,
    }:
    let
      system = "x86_64-linux";
      hosts = [
        "xos"
        "xfw"
      ];
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts (
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            llm-agents = llm-agents.packages.${system};
            nixos-hardware = nixos-hardware;
          };
          modules = [
            ./hosts/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                llm-agents = llm-agents.packages.${system};
              };
            }
          ];
        }
      );
    };
}
