{ pkgs, ... }: {
  programs.ssh.matchBlocks."inari" = {
    host = "inari";
    identityFile = "~/.ssh/paolo_at_kitsune";
    forwardAgent = true;
  };
}

