# nix

Let's have fun.

## TODO

- [ ] handle secrets for inari -- see https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md
- [ ] handle IP of inari in a way smarter than hardcoding

## NixOS in cloud

First, ensure you have an identity and upload the public key.

```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
hcloud context create Default # then login with a token
hcloud ssh-key create --public-key-from-file ~/.ssh/id_ed25519.pub --name "$(whoami)@$(hostname)"
```

Then, use `Makefile`.

### IPv6

Welp, apparently my ISP does IPv4 only; see http://test-ipv6.com/

## References

* https://github.com/iwilare/nix/tree/main
* https://github.com/mikidep/dotfiles
* https://www.youtube.com/watch?v=wr22CyoyRo4
* https://github.com/michaelpj/nixos-config
* https://github.com/dmadisetti/.dots

