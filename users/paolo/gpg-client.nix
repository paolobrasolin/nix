{pkgs, ...}: {
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

  programs.gpg.publicKeys = [
    {
      text = builtins.readFile ../../keys/pgp.pub;
      trust = "ultimate";
    }
  ];

  # NOTE: we enable the (safer) extra socket gor gpg-agent forwarding
  services.gpg-agent.enableExtraSocket = true;
  # NOTE: this is a socket tunnel to allow forwarding gpg-agent
  programs.ssh.matchBlocks."inari" = {
    remoteForwards = [
      {
        # TODO: how can I avoid hardcoded paths?
        bind.address = "/run/user/1000/gnupg/S.gpg-agent";
        host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
      }
    ];
  };
}
