{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
    ../shared/locale-it.nix
  ];

  # Boot loader
  boot.loader.grub = {
    # devices = [ ]; # NOTE: disko will add to the list all devices with an EF02 partition
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # Networking basics
  networking.hostName = "inari";

  # Timezone
  time.timeZone = "Europe/Rome";

  security.sudo.wheelNeedsPassword = false;

  # Basic terminal QOL
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # environment.pathsToLink = ["/share/zsh"];
  # environment.shells = [pkgs.zsh];
  # environment.enableAllTerminfo = true;

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

  # SSH connection
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ../../keys/id_ed25519.pub)
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  system.stateVersion = "23.11";
}
