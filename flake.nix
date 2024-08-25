{
  description = "Paolo's Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    cornelis.url = "github:isovector/cornelis";
    cornelis.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nix-darwin,
    nix-homebrew,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    homeConfigurations = {
      "paolo@kitsune" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          {
            nixpkgs.config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-25.9.0" # Required by obsidian
              ];
            };
          }
          ({
            inputs,
            outputs,
            ...
          }: {
            nixpkgs.overlays = [
              outputs.overlays.unstable-packages
              inputs.cornelis.overlays.cornelis
            ];
          })
          ./users/paolo/base.nix
          ./users/paolo/interactive.nix
          ./users/paolo/lazyvim.nix
          ./users/paolo/dev-server-lite.nix
          ./users/paolo/graphical.nix
          ./users/paolo/vscode-client.nix
          ./users/paolo/ssh-client.nix
          ./users/paolo/gpg-client.nix
          ./users/paolo/git-secret.nix
          ./users/paolo/texlive.nix
        ];
      };
    };

    darwinConfigurations = {
      "ebisu" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nixpkgs.hostPlatform = "aarch64-darwin";}
          ./hosts/ebisu/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          ./hosts/ebisu/nix-homebrew.nix
          ./hosts/ebisu/homebrew.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              users."Brasolin".imports = [
                ./hosts/ebisu/home.nix
                ./users/paolo/interactive.nix
                ./users/paolo/lazyvim.nix
                ./users/paolo/dev-server-lite.nix
                ./users/paolo/dev-server-mule.nix
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      "kitsune" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/kitsune/configuration.nix
          ./hosts/shared/nix.nix
          ./hosts/shared/locale.nix
          ./hosts/kitsune/swap.nix
          ./hosts/kitsune/printing.nix
          ./hosts/kitsune/ssh-client.nix
          ./hosts/kitsune/nixbuild.nix
        ];
      };

      "inari" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # "aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nix.nixPath = ["nixpkgs=${nixpkgs}"];} # TODO: why did i need this again?
          ({
            inputs,
            outputs,
            ...
          }: {
            nixpkgs.overlays = [
              outputs.overlays.unstable-packages
              inputs.cornelis.overlays.cornelis
            ];
          })
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
              extraSpecialArgs = {inherit inputs outputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              users."paolo".imports = [
                ./users/paolo/base.nix
                ./users/paolo/interactive.nix
                ./users/paolo/agda.nix
                # ./users/paolo/lunarvim.nix
                ./users/paolo/lazyvim.nix
                ./users/paolo/dev-server-lite.nix
                ./users/paolo/dev-server-mule.nix
                # ./users/paolo/vscode-server.nix
                ./users/paolo/gpg-server.nix
                ./users/paolo/git-secret.nix
                {home.packages = [(builtins.getFlake "path:./pkgs/aider-chat?lastModified=1721070396&narHash=sha256-H275mfKiSnk%2BbM/WSpRGR7HYWAtLiydw%2BcCbvKJlRjI%3D' to '/nix/store/4l2pw3hn62xw7klxkph5dpdqqvhabmr6-source' (hash 'sha256-H275mfKiSnk+bM/WSpRGR7HYWAtLiydw+cCbvKJlRjI=").packages.x86_64-linux.default];} # NOTE: you can update the lock with `nix flake prefetch path:./pkgs/aider-chat`
              ];
            };
          }
        ];
      };
    };
  };
}
