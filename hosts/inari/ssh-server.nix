{ ... }: let
  pkey = (builtins.readFile ../../keys/id_ed25519.pub);
in {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # I wanna SSH as root (to provision) and as paolo (to work).
  users.users.root.openssh.authorizedKeys.keys = [pkey];
  users.users.paolo.openssh.authorizedKeys.keys = [pkey];

  # I like to use SSH agent forwarding.
  programs.ssh.startAgent = true;
}
