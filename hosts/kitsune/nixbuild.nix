{ pkgs, ... }: {
  # FIXME: the key to the path is hardcoded because the user running nix-daemon (root) needs to access it; no forwarding, i guess? See https://docs.nixbuild.net/getting-started/ this assubes on every hos a key in that path exists, and that it's been added to nixbuild.net via the CLI
  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /home/paolo/.ssh/paolo_at_kitsune
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  nix = {
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
    buildMachines = [
      { hostName = "eu.nixbuild.net";
        system = "aarch64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
      }
      { hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
      }
    ];
  };
}

