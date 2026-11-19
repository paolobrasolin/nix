# A loud alert when Cloudflare WARP comes back on: a sound and an alert that
# stays on screen until clicked, with a button to pause WARP again. A Zero Trust
# device profile with Auto connect turns a paused WARP back on after a timeout,
# and otherwise the only sign is the menu bar icon.
#
# A home-manager module for macOS (afplay, osascript, and warp-cli from the
# Cloudflare WARP app); import it and set programs.warp-reconnect-alert.enable.
# The watcher runs as a launchd agent; `warp-reconnect-alert --test` shows the
# alert once.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.warp-reconnect-alert;
  script = pkgs.writeScriptBin "warp-reconnect-alert" (builtins.readFile ./warp-reconnect-alert);
in {
  options.programs.warp-reconnect-alert.enable =
    lib.mkEnableOption "a loud alert when Cloudflare WARP reconnects";

  config = lib.mkIf cfg.enable {
    home.packages = [script];

    launchd.agents.warp-reconnect-alert = {
      enable = true;
      config = {
        ProgramArguments = ["${script}/bin/warp-reconnect-alert"];
        RunAtLoad = true;
        KeepAlive = true;
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/warp-reconnect-alert.log";
      };
    };
  };
}
