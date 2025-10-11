{
  pkgs,
  inputs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #environment.systemPackages = with pkgs; [ vim ];

  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  nix = {
    # Necessary for using flakes on this system.
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["Brasolin" "@admin"];
      extra-trusted-users = ["Brasolin" "@admin"];
    };
    # Necessary to do linux builds on this system (i.e. ELF instead of Mach-O).
    # Ref: https://nixcademy.com/posts/macos-linux-builder/
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
        nix.settings.sandbox = false;
        services.openssh.enable = true;
      };
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  system.primaryUser = "Brasolin";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  security.pam.services.sudo_local.touchIdAuth = true;

  networking.hostName = "ebisu";
  networking.localHostName = "ebisu";

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # 25;
    KeyRepeat = 2; # 6;
    AppleScrollerPagingBehavior = true;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    AppleShowScrollBars = "Always";
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticInlinePredictionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    CreateDesktop = false;
    FXPreferredViewStyle = "Nlsv";
    QuitMenuItem = true;
    ShowPathbar = true;
  };

  system.defaults.dock = {
    mineffect = null;
    autohide = true;
    autohide-delay = 0.1;
    autohide-time-modifier = 0.1;
    static-only = true;
    showhidden = true;
    tilesize = 32;
    show-recents = false;
  };

  system.startup.chime = false;

  environment.shellAliases = {
    snix = "sudo darwin-rebuild switch --flake ~/pb/nix/flake.nix#ebisu";
  };

  fonts.packages = with pkgs; [nerd-fonts.hack];

  users.users."Brasolin".home = /Users/Brasolin;
  users.users."Brasolin" = {
    shell = pkgs.zsh;
  };

  environment.variables = {
    EDITOR = "vim";
  };

  # NOTE: this is the default in the DeterminateSystems conf and repairs nix-shell
  nix.extraOptions = ''
    extra-nix-path = nixpkgs=flake:nixpkgs
  '';
}
