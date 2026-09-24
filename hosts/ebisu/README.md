A nice guide is

https://nixcademy.com/posts/nix-on-macos/

however note the conflict with the /etc/nix/nix.conf file and the fact that you need some extra flags for bootstrapping

nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#ebisu

as documented in https://davi.sh/blog/2024/01/nix-darwin/

## Mosyle's `nix.custom.conf`

Mosyle keeps writing `/etc/nix/nix.custom.conf` (the DonQ GitHub token, for
Determinate-based fleet Macs), which makes nix-darwin abort activation. Each
rebuild moves it to `/etc/nix/mosyle-token.conf`, which `nix.conf` includes
(see `configuration.nix`). Check the token is loaded:

    nix config show access-tokens | grep -c github.com   # expect 1


