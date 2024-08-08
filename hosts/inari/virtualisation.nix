{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.docker-compose
  ];

  virtualisation.docker = {
    enable = true;
    liveRestore = false; # to enable swarm mode
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  users.users.paolo.extraGroups = ["docker"];
  # TODO: maybe consider running rootless instead
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };
}
