{
  description = "Paolo's Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    cornelis.url = "github:isovector/cornelis";
    cornelis.inputs.nixpkgs.follows = "nixpkgs";

    # aider-chat.url = "path:./pkgs/aider-chat";
    # aider-chat.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # # Supported systems for your flake packages, shell, etc.
    # systems = [
    #   "aarch64-linux"
    #   "i686-linux"
    #   "x86_64-linux"
    #   "aarch64-darwin"
    #   "x86_64-darwin"
    # ];
    # # This is a function that generates an attribute by calling a function you
    # # pass to it, with each system as an argument
    # forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    overlays = import ./overlays {inherit inputs;};
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    homeConfigurations = {
      "paolo@ebisu" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # TODO: is this ok for an M2?
        modules = [
          ./users/paolo/base.nix
          ./users/paolo/interactive.nix
          ./users/paolo/lazyvim.nix
        ];
      };

      "paolo@kitsune" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ({
            inputs,
            outputs,
            ...
          }: {
            # TODO: this module is inlined becaue keeping it in base.nix would upset paolo@inari. Refactor this to be neater.
            nixpkgs = {
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "electron-25.9.0" # Required by obsidian
                ];
              };
              overlays = [
                outputs.overlays.unstable-packages
                inputs.cornelis.overlays.cornelis
              ];
            };
          })
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
          ./users/paolo/texlive.nix
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
          ({inputs, ...}: {
            nixpkgs = {
              overlays = [
                outputs.overlays.unstable-packages
                # outputs.overlays.additions
                inputs.cornelis.overlays.cornelis
                # (_: _: {aider-chat = inputs.aider-chat.packages.x86_64-linux.default;})
              ];
            };
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
                {home.packages = [(builtins.getFlake "path:./pkgs/aider-chat?lastModified=1721069693&narHash=sha256-H275mfKiSnk%2BbM/WSpRGR7HYWAtLiydw%2BcCbvKJlRjI%3D").packages.x86_64-linux.default];} # NOTE: you can update the lock with `nix flake prefetch path:./pkgs/aider-chat`
                # ({inputs, ...}: {
                #   home.packages = [
                #     # Downloaded 'path:/home/paolo/nix/pkgs/aider-chat?lastModified=1721068517&narHash=sha256-H275mfKiSnk%2BbM/WSpRGR7HYWAtLiydw%2BcCbvKJlRjI%3D' to '/nix/store/4l2pw3hn62xw7klxkph5dpdqqvhabmr6-source' (hash 'sha256-H275mfKiSnk+bM/WSpRGR7HYWAtLiydw+cCbvKJlRjI=').
                #     # nixCopybuiltins.getFlake "git+file:///absolute/path/to/your/local/flake?rev=abcdef1234567890abcdef1234567890abcdef12"
                #     #
                #
                #     # (builtins.getFlake "path:/home/paolo/nix/pkgs/aider-chat").packages.x86_64-linux.default
                #     # inputs.aider-chat.packages.x86_64-linux.default
                #   ];
                # })
              ];
            };
          }
        ];
      };
    };
  };
}
