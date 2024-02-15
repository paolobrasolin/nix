{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    google-chrome
    telegram-desktop
    dmenu
    xclip
    pasystray
    zathura
    feh
    libreoffice-qt
  ];

  programs.alacritty.enable = true;

  # home.file.".config/i3status/config".source = ./files/i3status_config.txt;
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "--no-startup-id nm-applet"; }
      ];
      keybindings = let
        refresh_i3status = "killall -SIGUSR1 i3status";
        pactl = "exec --no-startup-id pactl";
      in lib.mkOptionDefault {
        "${modifier}+Shift+e" = "exec xfce4-session-logout";
        # NOTE: to map out keys use xev like `nix-shell -p xorg.xev --run "xev -event keyboard"`
        # TODO: maybe think about actkbd? -- see https://nixos.wiki/wiki/Actkbd
        # "XF86?" = ""; # (screen brightness -)
        # "XF86?" = ""; # (screen brightness +)
        # "XF86LaunchA" = "";
        # "XF86LaunchB" = "";
        # "XF86?" = ""; # (keyboard brightness -)
        # "XF86?" = ""; # (keyboard brightness +)
        # "XF86AudioPrev" = "";
        # "XF86AudioPlay" = "";
        # "XF86AudioNext" = "";
        "XF86AudioMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";
        "XF86AudioRaiseVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ +5% && ${refresh_i3status}";
        "XF86AudioLowerVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ -5% && ${refresh_i3status}";
        # "XF86Eject" = "";
        # NOTE: unfortunately there's no physical key for this
        # "XF86AudioMicMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";
      };
    };
    # extraConfig = builtins.readFile ./files/i3_extra_config.txt;
  };
    };
}
