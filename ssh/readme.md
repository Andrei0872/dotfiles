# SSH

Loads `~/.ssh/id_ed25519` into the macOS ssh-agent (passphrase from the Keychain) on first use, so forwarded-agent sessions (e.g. the Lima VM) can use it.

## Set up

```bash
ln -s  ~/Documents/repos/dotfiles/ssh/config ~/.ssh/config
```
