{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=512M
  '';

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages
  environment.systemPackages = with pkgs; [
    git
    pulseaudio # so pactl is available in $PATH
  ];

  # Networking basics
  networking.hostName = "kitsune";
  networking.networkmanager.enable = true;

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

  # Graphical session
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "xfce+i3";
      lightdm = {
        enable = true;
        greeters = {
          mini = {
            enable = true;
            user = "paolo";
            extraConfig = ''
              [greeter]
              show-password-label = false
              password-alignment = center
              password-input-width = 32

              [greeter-theme]
              window-color = "#1B1D1E"
              border-width = 0px
              password-border-width = 0px
            '';
          };
        };
      };
    };
    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
    windowManager.i3 = {
      enable = true;
      # extraPackages = with pkgs; [ i3status ];
    };
  };

  # Blue light management
  services.redshift.enable = true;
  location = {
    provider = "manual";
    latitude = 45.2;
    longitude = 11.9;
  };

  # Keyboard layout
  console.keyMap = "it2";
  services.xserver = {
    layout = "it";
    xkbVariant = "";
  };

  # Printing with CUPS
  services.printing.enable = true;

  # Sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Fonts
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["Hack"];})];
  fonts.fontconfig = {defaultFonts = {monospace = ["Hack Nerd Font"];};};

  # Basic terminal QOL
  programs.zsh.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  users.users.paolo = {
    isNormalUser = true;
    description = "Paolo Brasolin";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    # packages = with pkgs; [];
  };

  system.stateVersion = "23.11";
}
