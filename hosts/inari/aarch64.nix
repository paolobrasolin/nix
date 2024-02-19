{...}: {
  # This is required to successfully provision an aarch64-linux system.
  # See https://nixos.wiki/wiki/Install_NixOS_on_Hetzner_Cloud#AArch64_.28CAX_instance_type.29_specifics
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];
}
