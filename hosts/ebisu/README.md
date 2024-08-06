A nice guide is

https://nixcademy.com/posts/nix-on-macos/

however note the conflict with the /etc/nix/nix.conf file and the fact that you need some extra flags for bootstrapping

nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#ebisu

as documented in https://davi.sh/blog/2024/01/nix-darwin/


