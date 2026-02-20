# 🚀 ZSH Modern Setup for Omarchy (Arch-Based)

Setup completo para transformar seu terminal em um ambiente moderno, produtivo e profissional.

Este projeto foi feito **principalmente para Omarchy (base Arch Linux)**, mas também funciona em:

- Arch Linux
- Qualquer distro baseada em Arch

---
![setupZsh](https://github.com/user-attachments/assets/9600c26b-0501-41bf-ac63-5484e63efc31)

# 📦 O que este setup instala

- ZSH
- Oh My Zsh
- Powerlevel10k
- fzf
- eza (substituto moderno do exa)
- zoxide
- lazygit
- Plugins essenciais do ZSH
- ✅ **Suporte a pnpm (via Corepack)**

---

# 🧩 Sobre o pnpm

O setup ativa o **Corepack** (gerenciador oficial do Node.js) e instala automaticamente o:

- pnpm (última versão estável)

Isso permite usar:

```bash
pnpm install
pnpm dev
pnpm build
```

Sem necessidade de instalação manual global via npm.

---

# 📦 Compatibilidade

| Sistema                   | Suporte       |
| ------------------------- | ------------- |
| Omarchy                   | ✅ Oficial    |
| Arch Linux                | ✅ Testado    |
| Outras distros Arch-based | ✅ Compatível |

> ⚠️ Para Ubuntu/Debian/Fedora, utilize a versão universal do script.

---

# 🚀 Instalação

## 1️⃣ Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/zsh-setup-omarchy.git
cd zsh-setup-omarchy
```

---

## 2️⃣ Torne o script executável

```bash
chmod +x install-zsh.sh
```

---

## 3️⃣ Execute o script

```bash
./install-zsh.sh
```

---

## 4️⃣ Inicie o ZSH

```bash
zsh
```

Depois configure o tema:

```bash
p10k configure
```

---

# ⚠️ IMPORTANTE (Omarchy)

Omarchy inicia a sessão via `.bash_profile`.

Para garantir que o ZSH seja usado no login, edite:

```bash
nano ~/.bash_profile
```

Adicione no topo:

```bash
# Se não estiver no zsh, troca para zsh
if [ -z "$ZSH_VERSION" ]; then
  exec /usr/bin/zsh
fi

# Compatibilidade com bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
```

Isso garante que o sistema sempre iniciará no ZSH.

---

# 🧠 O que cada ferramenta faz

## 🔍 fzf

Fuzzy finder extremamente rápido para:

- Buscar arquivos
- Buscar histórico
- Navegar diretórios

Atalhos padrão:

- `CTRL + T` → Buscar arquivos
- `CTRL + R` → Buscar histórico
- `ALT + C` → Navegar diretórios

---

## 📂 eza

Substituto moderno do `ls`.

Recursos:

- Ícones automáticos
- Integração com Git
- Visualização em árvore
- Melhor formatação

Aliases configurados automaticamente:

```bash
alias ls="eza --icons"
alias ll="eza -lah --icons"
alias tree="eza --tree --icons"
```

---

## ⚡ zoxide

Substituto inteligente do `cd`.

Aprende seus diretórios mais utilizados.

Exemplo:

```bash
z backend
```

Quanto mais usa, mais preciso fica.

---

## 🐙 lazygit

Interface visual para Git no terminal.

Executar:

```bash
lg
```

Permite:

- Commit
- Branch
- Merge
- Push / Pull
- Resolver conflitos

Tudo via interface TUI.

---

## 🎨 Powerlevel10k

Tema avançado para ZSH.

Mostra:

- Git branch
- Status do repositório
- Versão do Node
- Tempo de execução do comando
- Status de erro

Configuração:

```bash
p10k configure
```

---

# 🔌 Plugins Instalados

## zsh-autosuggestions

Sugere comandos com base no histórico enquanto você digita.

Aceita sugestão com → (seta direita).

---

## zsh-syntax-highlighting

Coloração de sintaxe no terminal:

- Verde → comando válido
- Vermelho → comando inválido

Ajuda a evitar erros antes da execução.

---

## zsh-completions

Adiciona autocompletes extras para diversos comandos.

---

# 🛠 Desinstalar

```bash
sudo pacman -Rns zsh fzf eza zoxide lazygit
rm -rf ~/.oh-my-zsh
rm ~/.zshrc
```

Remova também o bloco adicionado no `.bash_profile`, se aplicável.

---

# 🎯 Resultado Final

Você terá:

- Shell moderno
- Autocomplete inteligente
- Navegação ultra rápida
- Git visual
- Suporte a pnpm
- Terminal profissional
- Alta produtividade

---

Feito para Omarchy ❤️
