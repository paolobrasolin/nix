{inputs, config, ...}: {
  sops = {
    # Ref: https://0xda.de/blog/2024/07/framework-and-nixos-sops-nix-secrets-management/
    # Ref: https://unmovedcentre.com/posts/secrets-management/
    # Ref: https://unmovedcentre.com/posts/remote-install-nixos-config/
    # defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age = {
      sshKeyPaths = [
        # "/Users/Brasolin/.ssh/pb-paolo_at_ebisu"
        # NOTE: to generate host keys on macOS simply turn on and off `System Settings > Sharing > Remote Login`
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      # keyFile = "~/.config/sops-nix/age/key.txt";
      # generateKey = true;
    };
  };

  # NOTE: ok, this works as desired.
  sops.secrets.".ssh/id_ed25519" = {
    sopsFile = "${inputs.nix-secrets}/keys/user/ebisu/Brasolin/id_ed25519.enc";
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    format = "binary";
  };
  home.file.".ssh/id_ed25519.pub" = {
    source = "${inputs.nix-secrets}/keys/user/ebisu/Brasolin/id_ed25519.pub";
  };
}
