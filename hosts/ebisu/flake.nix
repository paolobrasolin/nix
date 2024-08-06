{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#ebisu
    darwinConfigurations."ebisu" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ./configuration.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."ebisu".pkgs;
  };
}
