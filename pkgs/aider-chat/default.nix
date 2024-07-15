{
  #
  dream2nix,
  config,
  lib,
  ...
}: let
  src = config.deps.fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v0.43.4";
    hash = "sha256-/wjLi7HbPIHZtDqMUoSyLI0aH9YdDrByeaZ3t63KPGM=";
  };
in {
  imports = [
    dream2nix.modules.dream2nix.pip
  ];

  name = "aider-chat";
  version = "0.43.4";

  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) fetchFromGitHub;
    python = nixpkgs.python39;
    # TODO: implement the equivalent of `playwright install --with-deps chromium`
  };

  mkDerivation = {
    inherit src;
  };

  buildPythonPackage = {
    pythonImportsCheck = [
      "aider"
    ];
  };

  pip = {
    requirementsList = [
      "${src}"
    ];
  };
}
