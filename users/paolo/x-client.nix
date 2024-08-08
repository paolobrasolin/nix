{pkgs, ...}: {
  programs.ssh.matchBlocks."inari" = {
    compression = true;
    forwardX11 = true;
    forwardX11Trusted = false;
  };
}
