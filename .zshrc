# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================
# Zinit Configuration for Software Developers
# ============================================

# 設定 Zinit 安裝路徑
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# 如果 Zinit 尚未安裝，自動下載安裝
if [[ ! -d "$ZINIT_HOME" ]]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 載入 Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ============================================
# 基礎設定
# ============================================

# 啟用顏色支援
autoload -Uz colors && colors

# 歷史記錄設定
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# ============================================
# 主題 - Powerlevel10k (高度可客製化)
# ============================================

zinit ice depth=1
zinit light romkatv/powerlevel10k

# ============================================
# 核心增強插件
# ============================================

# 1. 語法高亮 - 讓命令更易讀
zinit light zdharma-continuum/fast-syntax-highlighting

# 2. 自動建議 - 根據歷史記錄自動建議命令
zinit light zsh-users/zsh-autosuggestions

# 3. 自動補全增強
zinit light zsh-users/zsh-completions

# ============================================
# 開發者工具
# ============================================

# Git 增強 - 提供豐富的 Git 別名和功能
zinit snippet OMZP::git

# Docker 補全
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

# Python 開發
zinit snippet OMZP::python
zinit snippet OMZP::pip

# Node.js / npm
zinit snippet OMZP::npm
zinit snippet OMZP::node

# 其他常用工具補全
zinit snippet OMZP::kubectl
zinit snippet OMZP::terraform

# Google Cloud SDK (installed via Homebrew)
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then
  source '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'
fi

# ============================================
# 生產力工具
# ============================================

# fzf - 模糊搜尋工具 (需要先安裝 fzf)
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# fzf 整合
zinit snippet OMZP::fzf

# z - 智能目錄跳轉
zinit light agkozak/zsh-z

# eza (現代化的 ls 替代品) 的整合
# 如果已安裝 eza，這會提供有用的別名
zinit ice wait lucid
zinit snippet OMZL::directories.zsh

# extract - 一鍵解壓縮各種格式
zinit snippet OMZP::extract

# colored-man-pages - 彩色 man 頁面
zinit snippet OMZP::colored-man-pages

# ============================================
# 進階功能
# ============================================

# sudo - 按兩次 ESC 在命令前加 sudo
zinit snippet OMZP::sudo

# copypath/copyfile - 複製當前路徑或文件內容
zinit snippet OMZP::copypath
zinit snippet OMZP::copyfile

# web-search - 直接從終端進行網頁搜尋
zinit snippet OMZP::web-search

# ============================================
# 補全系統設定
# ============================================

# 載入補全系統
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# 補全選單
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================
# 自定義別名
# ============================================

# 基本別名
if command -v eza &>/dev/null; then
  alias ll='eza -lah --git'
  alias la='eza -A'
  alias l='eza -F'
  alias lt='eza --tree --level=2'
else
  alias ll='ls -lah'
  alias la='ls -A'
  alias l='ls -CF'
fi

# Git 別名 (補充)
alias gs='git status'
alias gp='git pull'
alias gc='git commit'
alias gca='git commit -a'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'

# 快速編輯配置
alias zshconfig='${EDITOR:-vim} ~/.zshrc'
alias zshreload='source ~/.zshrc'

# 開發工具
alias py='python3'

# Docker 快捷指令
alias dps='docker ps'
alias dimg='docker images'
alias dex='docker exec -it'

# 安全操作
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# GCP
alias gcl='gcloud compute instances list'
alias gcs='gcloud compute ssh'
alias gke='gcloud container clusters'

# ============================================
# 環境變數
# ============================================

# 編輯器設定
export EDITOR='vim'
export VISUAL='vim'

# 語言設定
export LANG=zh_TW.UTF-8
export LC_ALL=zh_TW.UTF-8

# 開發相關路徑 (根據需要調整)
# export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node.js (nvm) - lazy load for faster startup
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { _load_nvm; nvm "$@" }
node() { _load_nvm; node "$@" }
npm() { _load_nvm; npm "$@" }
npx() { _load_nvm; npx "$@" }

# PostgreSQL (libpq)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Claude Code
export CLAUDE_CODE_EFFORT_LEVEL=max
export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1

# ============================================
# 按鍵綁定
# ============================================

# 使用 emacs 風格的按鍵綁定
bindkey -e

# Ctrl+arrow 跳字
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# ============================================
# 函數
# ============================================

# 創建目錄並進入
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 快速查找並進入 git 專案
cdp() {
    local dir
    dir=$(find ~/projects -maxdepth 2 -type d -name .git | sed 's|/.git||' | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# 顯示當前目錄大小
dirsize() {
    du -sh "${1:-.}" | cut -f1
}

# 快速切換 GCP 專案
gcp-switch() {
    if [ -z "$1" ]; then
        echo "目前專案: $(gcloud config get-value project)"
        echo ""
        echo "可用專案："
        gcloud projects list
    else
        gcloud config set project "$1"
        echo "已切換到專案: $1"
    fi
}

# 快速查看 GCP 資源
gcp-status() {
    echo "目前專案: $(gcloud config get-value project)"
    echo "目前帳號: $(gcloud config get-value account)"
    echo "目前區域: $(gcloud config get-value compute/region)"
    echo "目前地區: $(gcloud config get-value compute/zone)"
    echo ""
    echo "Compute Instances:"
    gcloud compute instances list --limit=5
}

# ============================================
# Powerlevel10k 設定
# ============================================

# 如果 p10k 配置檔存在就載入
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================
# 本地客製化配置
# ============================================

# 如果有本地配置文件就載入
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# echo "✨ Zinit 配置載入完成！"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
