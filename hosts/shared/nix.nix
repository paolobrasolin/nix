{
  nix = {
    settings = {
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
    };
  };
}
