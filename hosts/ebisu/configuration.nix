{
  pkgs,
  inputs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #environment.systemPackages = with pkgs; [ vim ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  networking.hostName = "ebisu";
  networking.localHostName = "ebisu";

  system.defaults.dock.mineffect = null;
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.1;
  system.defaults.dock.autohide-time-modifier = 0.1;

  system.startup.chime = false;

  environment.shellAliases = {
    snix = "darwin-rebuild switch --flake ~/nix/flake.nix#ebisu";
  };

  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["Hack"];})];

  users.users."Brasolin".home = /Users/Brasolin;
  users.users."Brasolin" = {
    shell = pkgs.zsh;
  };

  # NOTE: this is the default in the DeterminateSystems conf and repairs nix-shell
  nix.extraOptions = ''
    extra-nix-path = nixpkgs=flake:nixpkgs
  '';
}
