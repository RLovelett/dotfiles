# SSH agent configuration
if [[ -S $HOME/.1password/agent.sock ]]; then
  export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
elif [[ $OSTYPE == linux* ]]; then
  if [[ -z $SSH_AUTH_SOCK && -S $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh ]]; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
  fi
  [[ -z $DISPLAY ]] && export GPG_TTY=$(tty)
fi
