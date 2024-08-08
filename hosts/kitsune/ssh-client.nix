{...}: {
  # I like to use SSH agent forwarding.
  programs.ssh.startAgent = true;

  # NOTE: inari's IP is only semi-static
  networking.hosts."142.132.166.85" = ["inari"];

  services.dnsmasq = {
    enable = true;
    settings = {
      address = [
        ''/audiogiro.dev/142.132.166.85'' # NOTE: i don't love the fact it's overlapping with the host above
        # ''/inari/142.132.166.85'' # NOTE: i don't love the fact it's overlapping with the host above
        # ''/kitsune/127.0.0.1''
      ];
    };
  };
}
