{
  nix = {
    settings = {
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
