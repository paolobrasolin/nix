{...}: let
  keys = [
    (builtins.readFile ../../keys/pb-paolo_at_ebisu.pub)
    (builtins.readFile ../../keys/paolo_at_kitsune.pub)
  ];
in {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # I wanna SSH as root (to provision) and as paolo (to work).
  users.users.root.openssh.authorizedKeys.keys = keys;
  users.users.paolo.openssh.authorizedKeys.keys = keys;

  # I like to use SSH agent forwarding.
  programs.ssh.startAgent = true;
}
