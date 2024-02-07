{
  description = "Paolo's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, disko, ... }: {
    nixosConfigurations = {
      "kitsune" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kitsune/configuration.nix
          # NOTE: inari's IP is only semi-static
          { networking.hosts."142.132.166.85" = ["inari"]; }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."paolo" = {
              imports = [
                ./users/paolo/base.nix
                ./users/paolo/interactive.nix
                ./users/paolo/graphical.nix
              ];
              programs.ssh.matchBlocks."inari" = {
                host = "inari";
                forwardAgent = true;
                identityFile = "~/.ssh/id_ed25519";
              };
            };
          }
        ];
      };
      "inari" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/inari/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."paolo".imports = [
              ./users/paolo/base.nix
              ./users/paolo/interactive.nix
            ];
          }
        ];
      };
    };
  };
}
