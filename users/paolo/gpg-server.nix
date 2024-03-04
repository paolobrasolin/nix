{ pkgs, ... }: {
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

  programs.gpg.publicKeys = [
    {
      text = (builtins.readFile ../../keys/pgp.pub);
      trust = "ultimate";
    }
  ];

  # FIXME: apparently tunneling works fine until i snix; then, i need to reboot the remote server and I'm not sure why.
}

