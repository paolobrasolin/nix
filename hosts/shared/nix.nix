{
  nix = {
    settings = {
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
    };
  };
}
