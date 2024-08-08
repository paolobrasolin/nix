{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.gutenprint];
    # NOTE: we could enable browsing taking inspiration from https://discourse.nixos.org/t/printers-they-work/17545/2 but let's simply configure CUPS from the web interface at localhost:631 for now.
  };

  # NOTE: this allows auto-discovery of network printers
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  hardware.sane.enable = true;

  # NOTE: XP-310 series are supported by utsushi backend...
  # hardware.sane.extraBackends = [ pkgs.utsushi ];
  # services.udev.packages = [ pkgs.utsushi ];
  # NOTE: ... however, it supports WSD and airscan is enough to use it over wifi
  hardware.sane.extraBackends = [pkgs.sane-airscan];

  users.users.paolo.extraGroups = ["scanner" "lp"];
}
