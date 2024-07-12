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

  services.journald.extraConfig = ''
    SystemMaxUse=512M
  '';

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    git
    pkgs.unstable.codeium
  ];

  # Networking basics
  networking.hostName = "inari";

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
