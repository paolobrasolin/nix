{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
  ];

  # Boot loader
  boot.loader.grub = {
    # devices = [ ]; # NOTE: disko will add to the list all devices with an EF02 partition
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # Networking basics
  networking.hostName = "inari";

  # Timezone and locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Basic terminal QOL
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # SSH connection
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  programs.ssh.startAgent = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # root user
  security.sudo.wheelNeedsPassword = false;
  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ../../keys/id_ed25519.pub)
  ];

  users.users.paolo = {
    isNormalUser = true;
    description = "Paolo Brasolin";
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../keys/id_ed25519.pub)
    ];
  };

  system.stateVersion = "23.11";
}
