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

First, ensure you have an identity and upload the public key.

```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
hcloud context create Default # then login with a token
hcloud ssh-key create --public-key-from-file ~/.ssh/id_ed25519.pub --name "$(whoami)@$(hostname)"
```

Then, create the server and initialize it.

```bash
hcloud server create \
    --location nbg1 \
    --image ubuntu-22.04 \
    --type cx11 \
    --ssh-key paolo@kitsune \
    --firewall firewall-inari \
    --name inari
nix run github:nix-community/nixos-anywhere -- \
    --build-on-remote \
    --flake .#inari \
    root@$(hcloud server ip inari)
ssh-keygen -R $(hcloud server ip inari)
```

To update,
```bash
nixos-rebuild switch \
    --flake .#inari \
    --build-host root@$(hcloud server ip inari) \
    --target-host root@$(hcloud server ip inari)
```

To connect,
```bash
ssh $(hcloud server ip inari)
hcloud server ssh -u $(whoami) inari
```

## References

* https://github.com/iwilare/nix/tree/main
* https://github.com/mikidep/dotfiles
* https://www.youtube.com/watch?v=wr22CyoyRo4
* https://github.com/michaelpj/nixos-config
* https://github.com/dmadisetti/.dots

