{
  description = "Paolo's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, disko, ... }: {
    nixosConfigurations = {
      "kitsune" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kitsune/configuration.nix
          ./hosts/kitsune/swap.nix
          ./hosts/kitsune/printing.nix
          ./hosts/kitsune/ssh-client.nix
          ./hosts/kitsune/nixbuild.nix
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
                ./users/paolo/git-secret.nix
              ];
            };
          }
        ];
      };
      "inari" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # "aarch64-linux";
        modules = [
          { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
          ({ pkgs, ... }: { nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = final.system;
                config.allowUnfree = true;
              };
            })
          ]; })
          disko.nixosModules.disko
          ./hosts/inari/configuration.nix
          ./hosts/kitsune/swap.nix
          ./hosts/inari/virtualisation.nix
          ./hosts/inari/ssh-server.nix
          ./hosts/inari/gpg-server.nix
          ./hosts/kitsune/nixbuild.nix # TODO: clean this up
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."paolo".imports = [
              ./users/paolo/base.nix
              ./users/paolo/interactive.nix
              # ./users/paolo/vscode-server.nix
              ./users/paolo/gpg-server.nix
              ./users/paolo/git-secret.nix
            ];
          }
        ];
      };
    };
  };
}
