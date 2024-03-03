{ pkgs, ... }: {
  programs.ssh.matchBlocks."inari" = {
    host = "inari";
    identityFile = "~/.ssh/id_ed25519";
    forwardAgent = true;
  };
}

