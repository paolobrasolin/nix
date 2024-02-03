{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
  ];

  boot.loader.grub = {
    # devices = [ ]; # NOTE: disko will add to the list all devices with an EF02 partition
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "inari";

  time.timeZone = "Europe/Rome";

  # TODO: i18n, see kitsune

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ./hetzner.pub)
  ];

  # NOTE: what's this?
  # environment.systemPackages = map lib.lowPrio [
  #   pkgs.curl
  #   pkgs.gitMinimal
  # ];

  # systemd.tmpfiles.rules = [
  #   "d /home/${username}/.config 0755 ${username} users"
  #   "d /home/${username}/.config/lvim 0755 ${username} users"
  # ];

  # FIXME: change your shell here if you don't want zsh
  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.paolo = {
    isNormalUser = true;
    description = "Paolo Brasolin";
    extraGroups = [ "wheel" ]; # "docker"
    shell = pkgs.zsh;
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./hetzner.pub)
    ];
  };

  # virtualisation.docker = {
  #   enable = true;
  #   enableOnBoot = true;
  #   autoPrune.enable = true;
  # };

  # nix = {
  #   settings = {
  #     trusted-users = [username];
  #     # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
  #     # access-tokens = [
  #     #   "github.com=${secrets.github_token}"
  #     #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
  #     # ];

  #     accept-flake-config = true;
  #     auto-optimise-store = true;
  #   };

  #   registry = {
  #     nixpkgs = {
  #       flake = inputs.nixpkgs;
  #     };
  #   };

  #   nixPath = [
  #     "nixpkgs=${inputs.nixpkgs.outPath}"
  #     "nixos-config=/etc/nixos/configuration.nix"
  #     "/nix/var/nix/profiles/per-user/root/channels"
  #   ];

  #   package = pkgs.nixFlakes;
  #   extraOptions = ''experimental-features = nix-command flakes'';

  #   gc = {
  #     automatic = true;
  #     options = "--delete-older-than 7d";
  #   };
  # };

  system.stateVersion = "23.11";
}
