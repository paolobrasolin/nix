{ ... }: {
  # I like to use SSH agent forwarding.
  programs.ssh.startAgent = true;

  # NOTE: inari's IP is only semi-static
  networking.hosts."142.132.166.85" = ["inari"];
}
