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

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    ...
  }: let
    nixpkgsUnstableOverlay = _: {
      nixpkgs.overlays = [
        (final: _prev: {
          unstable = import nixpkgs-unstable {
            inherit (final) system;
            config.allowUnfree = true;
          };
        })
      ];
    };
  in {
    nixosConfigurations = {
      "kitsune" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsUnstableOverlay
          ./hosts/kitsune/configuration.nix
          ./hosts/shared/nix.nix
          ./hosts/shared/locale.nix
          ./hosts/kitsune/swap.nix
          ./hosts/kitsune/printing.nix
          ./hosts/kitsune/ssh-client.nix
          ./hosts/kitsune/nixbuild.nix
          # {
          #   nixpkgs.config.permittedInsecurePackages = [
          #     "electron-25.9.0" # Required by obsidian
          #   ];
          # }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."paolo" = {
                imports = [
                  ./users/paolo/base.nix
                  ./users/paolo/interactive.nix
                  # ./users/paolo/lunarvim.nix
                  ./users/paolo/lazyvim.nix
                  ./users/paolo/dev-server-lite.nix
                  ./users/paolo/graphical.nix
                  # ./users/paolo/vscode-client.nix
                  ./users/paolo/ssh-client.nix
                  ./users/paolo/gpg-client.nix
                  ./users/paolo/git-secret.nix
                ];
              };
            };
          }
        ];
      };
      "inari" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # "aarch64-linux";
        modules = [
          {nix.nixPath = ["nixpkgs=${nixpkgs}"];}
          nixpkgsUnstableOverlay
          disko.nixosModules.disko
          ./hosts/inari/configuration.nix
          ./hosts/shared/nix.nix
          ./hosts/shared/locale.nix
          ./hosts/inari/swap.nix
          ./hosts/inari/virtualisation.nix
          ./hosts/inari/ssh-server.nix
          ./hosts/inari/gpg-server.nix
          ./hosts/kitsune/nixbuild.nix # TODO: clean this up
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."paolo".imports = [
                ./users/paolo/base.nix
                ./users/paolo/interactive.nix
                # ./users/paolo/lunarvim.nix
                ./users/paolo/lazyvim.nix
                ./users/paolo/dev-server-lite.nix
                ./users/paolo/dev-server-mule.nix
                # ./users/paolo/vscode-server.nix
                ./users/paolo/gpg-server.nix
                ./users/paolo/git-secret.nix
              ];
            };
          }
        ];
      };
    };
  };
}
