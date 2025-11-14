STAMP="$(date +%F)_$(sw_vers -productVersion)"
sudo mv /etc/zshrc    "/etc/zshrc.$STAMP.before-nix-darwin"
sudo mv /etc/zprofile "/etc/zprofile.$STAMP.before-nix-darwin"
