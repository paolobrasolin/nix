{
  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "google-chrome"
      # "firefox"
      "telegram"
      "dbeaver-community"
      "zotero"
      "postman"
      "zoom"
      "r"
      "lookaway"
      "stats"
      "qgis"
      "cloudflare-warp"
      "switchhosts"
      "devpod"
      "orbstack"
      "obsidian"
      "claude-code@latest"
      "background-music"
      # "blackhole-2ch"
      "cyberduck"
    ];
    brews = [
      "mysql-client"
      # "libpq"
      "udunits" # for R stuff
      "zeromq" # for R stuff
      "git" # for ComfyUI
      "harfbuzz" # libremap
      "djvulibre"
      "djview4"
      # "opencode"
      "tor"
    ];
  };
}
