{
  # NOTE: we're on Hetzner, so we can use DHCP for ipv4 but must hardcode address and gateway for ipv6
  # NOTE: here are a few relevant references:
  # * https://nixos.wiki/wiki/Install_NixOS_on_Hetzner_Cloud
  # * https://nixos.wiki/wiki/Install_NixOS_on_Hetzner_Online
  # * https://nixos.wiki/wiki/Networking

  # systemd.network.enable = true;
  # systemd.network.networks."10-wan" = {
  #   networkConfig.DHCP = "ipv4"; # we use DHCP for ipv4
  #   matchConfig.Name = "enp1s0"; # either ens3 (amd64) or enp1s0 (arm64)
  #   address = ["2a01:4f8:1c1b:75e3::/64"]; # ipv6 address assigned by hetzner
  #   routes = [{routeConfig.Gateway = "fe80::1";}]; # hetzner gateway address
  # };
  #
  # NOTE: the snippet above works, but creates potential conflict with these defaults:
  # networking.useNetworkd = false;
  # networking.useDHCP = true;
  # NOTE: we use the following configuration instead which should be equivalent:
  networking = {
    interfaces = {
      "enp1s0".ipv6.addresses = [
        {
          address = "2a01:4f8:1c1b:75e3::";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  virtualisation.docker = {
    daemon.settings = {
      # NOTE: see https://docs.docker.com/config/daemon/ipv6/#use-ipv6-for-the-default-bridge-network
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80"; # NOTE: required if ipv6 = true
      experimental = true;
      ip6tables = true;
    };
  };

  # NOTE: docker swarm services still haven't ipv6 connectivity
}
