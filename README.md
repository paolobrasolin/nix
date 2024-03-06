# nix

Let's have fun.

## TODO

- [ ] handle secrets for inari -- see https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md
- [ ] handle IP of inari in a way smarter than hardcoding

## Nix~~OS~~ in cloud

First, ensure you have an identity and upload the public key.

```bash
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)"
hcloud context create Default # then login with a token
hcloud ssh-key create --public-key-from-file ~/.ssh/id_ed25519.pub --name "$(whoami)@$(hostname)"
```

Then, use `Makefile`.

### IPv6

Welp, apparently my ISP does IPv4 only; see http://test-ipv6.com/

## NixOS on mobile

It's definitely doable on an Android phone thanks to [Nix-on-Droid](https://github.com/nix-community/nix-on-droid):

1. Install [F-Droid](https://f-droid.org/).
2. Install Nix-on-Droid using F-Droid.
3. Start the Nix app and give it the url of a boostrap tarball from the releases list at https://nix-on-droid.unboiled.info/ -- the following assumes you set it up with flakes when asked for confirmation.

To do anything meaningful, you'll probably need to set up the `nixpkgs` channel and perhaps also throw in `home-manager`:

```bash
nix-channel --add https://nixos.org/channels/nixos-23.11 nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
```

Also, you'll probably want to ssh into your phone as typing on a screen gets old real quick:

1. Add `openssh` to `environment.packages` in `~/.config/nix-on-droid/nix-on-droid.nix`.
2. Run `nix-on-droid switch --flake ~/.config/nix-on-droid#default` to install `openssh`.
3. Create host keys:
    ```bash
    mkdir -p ~/.ssh
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/ssh_host_rsa_key
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/ssh_host_ed25519_key
    ```
4. Create `sshd` configuration:
    ```bash
    mkdir -p ~/.ssh
    echo "Port 2222" > ~/.ssh/sshd_config
    echo "HostKey $(realpath ~/.ssh/ssh_host_rsa_key)" >> ~/.ssh/sshd_config
    echo "HostKey $(realpath ~/.ssh/ssh_host_ed25519_key)" >> ~/.ssh/sshd_config
    ```
5. Add a public key to authorize:
    ```bash
    mkdir -p ~/.ssh
    echo "<PASTE PUB KEY HERE>" >> ~/.ssh/authorized_keys
    ```
6. Start `sshd` (note that absolute paths are a requirement):
    ```bash
    $(realpath ~)/.nix-profile/bin/sshd -f $(realpath ~)/.ssh/sshd_config
    ```
    To stop it you'll probably want to `nix-shell -p killall --run "killall sshd"`.
7. Connect your phone and a machine with the authorized keypair to the same WiFi and
    ```bash
    ssh -p 2222 -l nix-on-droid -i <PATH TO PVT KEY> <IP OF PHONE>
    ```
    To get the OP of the phone use its GUI or maybe do `nix-shell -p nettools --run "ifconfig wlan0"`.

Boom, you're in.

**TODO:** what'sabove is an acceptable kludge to get into your phone with a minimal amount of typing, but it begs the question -- is there a cleaner way? Having something like NixOS's 'services.openssh' would be ideal.

## References

* https://github.com/iwilare/nix/tree/main
* https://github.com/mikidep/dotfiles
* https://www.youtube.com/watch?v=wr22CyoyRo4
* https://github.com/michaelpj/nixos-config
* https://github.com/dmadisetti/.dots

