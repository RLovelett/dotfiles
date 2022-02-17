# See Wiki

* [macOS](https://github.com/RLovelett/dotfiles/wiki/macOS)
* [Ubuntu | Fedora | Linux](https://github.com/RLovelett/dotfiles/wiki/Linux)

## YubiKey, SSH, GnuPG, macOS

Most of this is lifted from Kirill Kuznetsov's article [Stick with security:
YubiKey, SSH, GnuPG, macOS](https://evilmartians.com/chronicles/stick-with-security-yubikey-ssh-gnupg-macos) from June 11, 2018.

See [Script management with launchd in Terminal on Mac](https://support.apple.com/guide/terminal/script-management-with-launchd-apdc6c1077b-5d5d-4d35-9c19-60f2397b2369/mac) for more information about `launchctl`.

```bash
cp sh.brew.gnupg.gpg-agent.plist sh.brew.gnupg.link-ssh-auth-socket.plist $HOME/Library/LaunchAgents
launchctl load -F $HOME/Library/LaunchAgents/sh.brew.gnupg.gpg-agent.plist
launchctl load -F $HOME/Library/LaunchAgents/sh.brew.gnupg.link-ssh-auth-socket.plist
```

Verify everything is working:

```bash
$ launchctl list | grep sh.brew.gnupg
-	0	sh.brew.gnupg.gpg-agent
-	0	sh.brew.gnupg.link-ssh-auth-sock
```

```bash
$ pgrep -fl gpg-agent
50890 gpg-agent --homedir /Users/lovelettr/.gnupg --use-standard-socket --daemon
```

```bash
$ ssh-add -L
ssh-rsa AAAAB3NzaC...5UNE54ZNTQ== cardno:5413447
```
