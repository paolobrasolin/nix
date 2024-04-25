{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    unstable.google-chrome
    telegram-desktop
    dmenu
    xclip
    pasystray
    zathura
    feh
    libreoffice-qt
    # obsidian
  ];

  programs.alacritty.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      fonts = { names = [ "Hack Nerd Font" ]; size = 10.0; };
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "--no-startup-id nm-applet"; }
      ];
      window = {
        border = 1;
        hideEdgeBorders = "smart";
      };
      workspaceAutoBackAndForth = true;
      keybindings = let
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
        "XF86AudioMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        # "XF86Eject" = "";
        # NOTE: unfortunately there's no physical key for this
        # "XF86AudioMicMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
      };
      bars = [
        {
          fonts = { names = [ "Hack Nerd Font" ]; size = 10.0; };
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
        }
      ];
    };
    # extraConfig = builtins.readFile ./files/i3_extra_config.txt;
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        icons = "material-nf";
        theme = "plain";
        blocks = [
          # NOTE: these are the Bose On-Ear
          # { block = "bluetooth"; mac = "2C:41:A1:7F:34:B6"; }
          { block = "net"; }
          { block = "temperature"; }
          {
            block = "cpu";
            format = " $icon $utilization $barchart ";
            interval = 2;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:2) $mem_used.eng(prefix:Gi,force_prefix:true) ";
            interval = 2;
          }
          {
            block = "memory";
            format = " $icon $swap_used_percents.eng(w:2) $swap_used.eng(prefix:Gi,force_prefix:true) ";
            interval = 2;
          }
          {
            block = "disk_space";
            info_type = "used";
            warning = 80.0;
            alert = 90.0;
            format = " $icon $percentage $used ";
          }
          {
            block = "battery";
            format = " $icon $percentage $time ";
            full_threshold = 100;
            empty_threshold = 0;
          }
          { block = "backlight"; }
          { block = "sound"; }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %F %R') ";
            interval = 60;
          }
        ];
      };
    };
  };
}
