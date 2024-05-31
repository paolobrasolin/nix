{pkgs, ...}: {
  home.packages = [
    pkgs.agda
    # (pkgs.agda.withPackages (ps: [ps.standard-library]))
  ];

  programs.neovim = {
    extraPackages = [pkgs.cornelis];
  };
}
