{ ... }: {
  # NOTE: this looks out of place, but it's only relevant for the tunneling of gpg-agent.
  services.openssh.settings.StreamLocalBindUnlink = true;
}
