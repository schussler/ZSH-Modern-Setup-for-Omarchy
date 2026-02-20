#!/usr/bin/env bash
set -e

echo "🔄 Detectando gerenciador de pacotes..."

# -----------------------------
# DETECÇÃO DE PACOTE
# -----------------------------

if command -v apt >/dev/null 2>&1; then
  PKG_INSTALL="sudo apt install -y"
  PKG_UPDATE="sudo apt update"
  EXTRA_PACKAGES="fonts-powerline"
elif command -v dnf >/dev/null 2>&1; then
  PKG_INSTALL="sudo dnf install -y"
  PKG_UPDATE="sudo dnf check-update"
  EXTRA_PACKAGES="powerline-fonts"
elif command -v pacman >/dev/null 2>&1; then
  PKG_INSTALL="sudo pacman -S --noconfirm"
  PKG_UPDATE="sudo pacman -Sy"
  EXTRA_PACKAGES="powerline-fonts"
else
  echo "❌ Gerenciador de pacotes não suportado."
  exit 1
fi

echo "📦 Atualizando sistema..."
$PKG_UPDATE

echo "📦 Instalando pacotes base..."
$PKG_INSTALL zsh git curl wget fzf eza zoxide lazygit nodejs npm yarn pnpm $EXTRA_PACKAGES

echo "🐚 Definindo ZSH como shell padrão..."
chsh -s "$(which zsh)"

# -----------------------------
# OH MY ZSH
# -----------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# -----------------------------
# POWERLEVEL10K
# -----------------------------

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Instalando Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# -----------------------------
# PLUGINS
# -----------------------------

echo "✨ Instalando plugins..."

git clone https://github.com/zsh-users/zsh-autosuggestions \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-completions \
  $ZSH_CUSTOM/plugins/zsh-completions 2>/dev/null || true

# 🔥 Instala plugin pnpm manualmente (caso não exista)
if [ ! -d "$ZSH_CUSTOM/plugins/pnpm" ]; then
  echo "📦 Instalando plugin pnpm..."
  git clone https://github.com/ntnyq/omz-plugin-pnpm \
    $ZSH_CUSTOM/plugins/pnpm
fi

# -----------------------------
# .ZSHRC CONFIG
# -----------------------------

echo "⚙️ Gerando .zshrc..."

cat > ~/.zshrc << 'EOF'
# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  sudo
  docker
  npm
  pnpm
  yarn
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Histórico
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# -----------------------------
# FZF
# -----------------------------
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# -----------------------------
# EZA
# -----------------------------
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias tree="eza --tree --icons"

# -----------------------------
# ZOXIDE
# -----------------------------
eval "$(zoxide init zsh)"

# -----------------------------
# UTILIDADES
# -----------------------------
alias cls="clear"
alias update="sudo pacman -Syu"
alias lg="lazygit"

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "🎉 Instalação concluída!"
echo "➡️ Reinicie o terminal ou rode: zsh"
echo "➡️ Depois rode: p10k configure"