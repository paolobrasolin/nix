# terminal-notifier 3.x from its release (a universal, ad-hoc signed app):
# nixpkgs only has 2.0.0, an x86_64 build that needs Rosetta.
#
# Just the app, no command: macOS lets it post notifications only from an
# Applications folder, so it can't run from the nix store (nor from Homebrew's
# Cellar). default.nix here copies it into ~/Applications.
{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "terminal-notifier";
  version = "3.1.0";

  src = fetchzip {
    url = "https://github.com/julienXX/terminal-notifier/releases/download/${version}/terminal-notifier-${version}.zip";
    hash = "sha256-WbkwxlOsR445RBez7oK4LURs4MifO1vK7b3m1MGxq90=";
    stripRoot = false;
  };

  dontBuild = true;
  # Keep the bundle as released: stripping would break its code signature.
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/Applications
    cp -R terminal-notifier.app $out/Applications/
  '';

  meta = {
    description = "Send macOS notifications from the command line";
    homepage = "https://github.com/julienXX/terminal-notifier";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
