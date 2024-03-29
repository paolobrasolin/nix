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

  # This should increase the size of the tmpfs at /run/user/1000 for nix shells
  services.logind.extraConfig = "RuntimeDirectorySize=80%";
  # boot.tmp = { useTmpfs = true; tmpfsSize = "80%"; };
  # TODO: we'll need a swap partition sooner or later

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    git
    unstable.codeium
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

  security.sudo.wheelNeedsPassword = false;

  users.users.paolo = {
    isNormalUser = true;
    description = "Paolo Brasolin";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    # packages = with pkgs; [];
  };

  system.stateVersion = "23.11";
}
