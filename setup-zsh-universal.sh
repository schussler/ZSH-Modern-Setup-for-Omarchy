#!/usr/bin/env bash
set -e

echo "🔎 Detectando sistema..."

# -----------------------------
# DETECT PACKAGE MANAGER
# -----------------------------

if command -v apt >/dev/null 2>&1; then
  PKG="apt"
  sudo apt update
  sudo apt install -y zsh git curl wget unzip nodejs npm
elif command -v dnf >/dev/null 2>&1; then
  PKG="dnf"
  sudo dnf install -y zsh git curl wget unzip nodejs npm
elif command -v pacman >/dev/null 2>&1; then
  PKG="pacman"
  sudo pacman -Sy --noconfirm zsh git curl wget unzip nodejs npm
else
  echo "❌ Sistema não suportado."
  exit 1
fi

# -----------------------------
# PNPM VIA COREPACK (UNIVERSAL)
# -----------------------------

echo "📦 Ativando Corepack..."
sudo corepack enable
sudo corepack prepare pnpm@latest --activate

# -----------------------------
# INSTALAR EZA (BINÁRIO OFICIAL)
# -----------------------------

if ! command -v eza >/dev/null 2>&1; then
  echo "📦 Instalando eza..."
  EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep tag_name | cut -d '"' -f4)

  wget -q https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
  tar -xzf eza_x86_64-unknown-linux-gnu.tar.gz
  sudo mv eza /usr/local/bin/
  rm -rf eza_x86_64-unknown-linux-gnu.tar.gz
fi

# -----------------------------
# INSTALAR FERRAMENTAS GERAIS
# -----------------------------

if ! command -v fzf >/dev/null 2>&1; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

if ! command -v zoxide >/dev/null 2>&1; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

if ! command -v lazygit >/dev/null 2>&1; then
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4)
  wget -q https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz
  tar xf lazygit_*_Linux_x86_64.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit_*_Linux_x86_64.tar.gz
fi

# -----------------------------
# OH MY ZSH
# -----------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# -----------------------------
# POWERLEVEL10K
# -----------------------------

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# -----------------------------
# PLUGINS
# -----------------------------

git clone https://github.com/zsh-users/zsh-autosuggestions \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-completions \
  $ZSH_CUSTOM/plugins/zsh-completions 2>/dev/null || true

# -----------------------------
# GERAR .ZSHRC UNIVERSAL
# -----------------------------

cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  sudo
  docker
  npm
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

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# EZA
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias tree="eza --tree --icons"

# ZOXIDE
eval "$(zoxide init zsh)"

# Update dinâmico
if command -v apt >/dev/null 2>&1; then
  alias update="sudo apt update && sudo apt upgrade -y"
elif command -v pacman >/dev/null 2>&1; then
  alias update="sudo pacman -Syu"
elif command -v dnf >/dev/null 2>&1; then
  alias update="sudo dnf upgrade --refresh -y"
fi

alias lg="lazygit"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "🎉 Setup universal concluído!"
echo "➡️ Rode: zsh"
echo "➡️ Depois: p10k configure"