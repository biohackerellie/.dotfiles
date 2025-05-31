
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

export PNPM_HOME="/home/ellie/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# bun completions
[ -s "/home/ellie/.bun/_bun" ] && source "/home/ellie/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# homebrew

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  # If you're using Linux, you'll want this enabled
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi



export GPG_TTY=$(tty)

export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
# Shell integrations
eval "$(fzf --zsh)"
# eval "$(zoxide init --cmd cd zsh)"
eval "$(zoxide init zsh )"
export PATH="$PATH:$HOME/.cargo/env"
export PATH="$PATH:$HOME/.cargo/bin"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:/opt/nvim-linux64/bin"
export WARP_ENABLE_WAYLAND=1
export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
export BROWSER=google-chrome


# Aliases
alias ls='ls --color'
alias codecfg="cp -R $HOME/.dotfiles/.vscode ."
alias upg='sudo -iu postgres psql'
if [ -e /home/ellie/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ellie/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/ellie/.lmstudio/bin"
# End of LM Studio CLI section
