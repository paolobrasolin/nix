{...}: {
  nix-homebrew = {
    enable = true;
    # enableRosetta = true; # TODO: install rosetta
    user = "Brasolin";
    # We use a fully declarative setup of Homebrew.
    mutableTaps = false;
    # No taps. Formulae and casks are installed from Homebrew's JSON API
    # (formulae.brew.sh), the default since Homebrew 4.0: Homebrew 4.6.4+
    # rejects loading formulae from outside Library/Taps, and nix-homebrew's
    # tap symlinks resolve into /nix/store. `brew bundle` has been part of
    # brew itself since homebrew-bundle was archived (2025-04).
  };
}
