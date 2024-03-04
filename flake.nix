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
          ./hosts/kitsune/printing.nix
          ./hosts/kitsune/ssh-client.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."paolo" = {
              imports = [
                ./users/paolo/base.nix
                ./users/paolo/interactive.nix
                ./users/paolo/graphical.nix
                # ./users/paolo/vscode-client.nix
                ./users/paolo/ssh-client.nix
                ./users/paolo/gpg-client.nix
              ];
            };
          }
        ];
      };
      "inari" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # "aarch64-linux";
        modules = [
          { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
          disko.nixosModules.disko
          ./hosts/inari/configuration.nix
          ./hosts/inari/virtualisation.nix
          ./hosts/inari/ssh-server.nix
          ./hosts/inari/gpg-server.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."paolo".imports = [
              ./users/paolo/base.nix
              ./users/paolo/interactive.nix
              # ./users/paolo/vscode-server.nix
              ./users/paolo/gpg-server.nix
            ];
          }
        ];
      };
    };
  };
}
