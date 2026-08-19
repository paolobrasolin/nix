{inputs, ...}: {
  nix-homebrew = {
    enable = true;
    # enableRosetta = true; # TODO: install rosetta
    user = "Brasolin";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;
    # Formulae and casks are installed from Homebrew's JSON API
    # (formulae.brew.sh), the default since Homebrew 4.0. Don't pin
    # homebrew-core/homebrew-cask as git taps: Homebrew 4.6.4+ rejects loading
    # formulae from a path outside Library/Taps, and nix-homebrew's tap
    # symlinks resolve into /nix/store, tripping that check during
    # `brew bundle`. Only homebrew-bundle is a real command, so it stays.
    taps = {
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
  };
}
