{
  # TODO: think about https://github.com/hakavlad/nohang
  # TODO: think about memory limits with cgroups

  swapDevices = [ {
    device = "/swapfile";
    size = 2*1024;
    priority = 0; # last resort
    # randomEncryption.enable = true; # TODO: better safe than sorry
  } ];

  zramSwap = {
    enable = true;
    priority = 5;
    # zramSwap.writebackDevice = "/swapfile" # would this even help?
  };
}
