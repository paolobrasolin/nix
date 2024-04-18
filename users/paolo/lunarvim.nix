{pkgs, ...}: {
  home.packages = with pkgs; [
    lunarvim
  ];

  home.file.".config/lvim/config.lua".source = ./files/lunarvim/config.lua;
}
