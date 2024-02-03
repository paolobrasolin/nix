# nix

Let's have fun.

## TODO

- [ ] handle secrets for inari -- see https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md
- [ ] handle IP of inari in a way smarter than hardcoding

## Machines

Machine-level configurations are in `machines/`.

To set one up,
```
sudo ln -vfisr machines/<MACHINE>/*.nix /etc/nixos/
```

### Hetzner (`inari`)

```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
# => ~/.ssh/id_ed25519
# To create,
hcloud context create Default
hcloud ssh-key create --public-key-from-file ~/.ssh/id_ed25519.pub --name "$(whoami)@$(hostname)"
# Make it the default via web interface.
hcloud server create --image ubuntu-22.04 --type cx11 --name inari
# TODO: firewall
hcloud server ip inari
# => <IP>
# To init,
nix run github:nix-community/nixos-anywhere -- --flake .#inari root@<IP>
# Then remove the host from ~/.ssh/known_hosts
# To update,
nixos-rebuild switch --flake .#inari --target-host root@<IP>
# To connect,
ssh <USER>@<IP>
# Or maybe even use the hostname from the configured hosts.
```

## References

* https://github.com/iwilare/nix/tree/main
* https://github.com/mikidep/dotfiles
* https://www.youtube.com/watch?v=wr22CyoyRo4
* https://github.com/michaelpj/nixos-config
* https://github.com/dmadisetti/.dots

