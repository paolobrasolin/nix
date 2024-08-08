{pkgs, ...}: let
  # NOTE: git-secret defaults to forcing loopback pinentry -- see https://github.com/sobolevn/git-secret/blob/01cc4430c708c8ca23cbef1c396cd5fe5b8bebc0/src/_utils/_git_secret_tools.sh#L797-L801 -- and that causes an exit code 2 from gpg when tunneling the agent, therefore we patch https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/applications/version-management/git-secret/default.nix to explicitly set default gpg value, which works fine.
  git-secret-override = pkgs.symlinkJoin {
    name = "git-secret-override";
    paths = [pkgs.git-secret];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/git-secret \
        --set SECRETS_PINENTRY default
    '';
  };
in {
  home.packages = [git-secret-override];
}
