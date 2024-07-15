{pkgs ? import <nixpkgs> {}, ...}: {
  aider-chat = pkgs.python3Packages.callPackage ./aider-chat {};
}
