#!/usr/bin/env bash
# 在新的 Mac 上設定 vim：安裝 Homebrew 套件、連結 .vimrc、安裝外掛。
# 重複執行也沒關係，已經完成的步驟會略過。
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m注意：\033[0m%s\n' "$*" >&2; }
fail() { printf '\033[1;31m錯誤：\033[0m%s\n' "$*" >&2; exit 1; }

# 1. Homebrew（剛裝好時 PATH 可能還沒有 brew）
if ! command -v brew >/dev/null 2>&1; then
  [[ -x /opt/homebrew/bin/brew ]] || fail "找不到 Homebrew，請先到 https://brew.sh 安裝後再執行。"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. vim 與外掛需要的工具
#    ripgrep：fzf 找檔案、:Find 搜尋內容
#    universal-ctags：Tagbar（F4）
#    flake8：ALE 檢查 Python
info "安裝 vim、ripgrep、universal-ctags、flake8"
brew install vim ripgrep universal-ctags flake8

VIM="$(brew --prefix)/bin/vim"

# 3. Homebrew 的 vim 執行時才載入 Python，要裝它指定的那個版本，
#    UltiSnips 和 jedi-vim 才能用。
vim_eval() { "$VIM" -N -es -u NONE -c 'redir! > /dev/stdout' -c "echo $1" -c 'qa!' | tr -d '\r\n'; }
python_formula="$(vim_eval '&pythonthreedll' | grep -o 'python@3\.[0-9]*' || true)"
if [[ -n "$python_formula" ]]; then
  info "安裝 vim 需要的 $python_formula"
  brew install "$python_formula"
fi
[[ "$(vim_eval 'has("python3")')" == 1 ]] || fail "vim 還是載入不了 Python 3，請檢查 brew install vim 的提示。"

# 4. 連結 .vimrc（原本有其他 .vimrc 的話先備份）
target="$HOME/.vimrc"
if [[ -L "$target" && "$(readlink "$target")" == "$DOTFILES/.vimrc" ]]; then
  info "~/.vimrc 已經連結好了"
else
  if [[ -e "$target" || -L "$target" ]]; then
    backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    info "備份原本的 ~/.vimrc 到 $backup"
    mv "$target" "$backup"
  fi
  ln -s "$DOTFILES/.vimrc" "$target"
  info "已連結 ~/.vimrc -> $DOTFILES/.vimrc"
fi

# 5. 安裝 vim-plug 和所有外掛
plug="$HOME/.vim/autoload/plug.vim"
if [[ ! -f "$plug" ]]; then
  info "下載 vim-plug"
  curl -fsSLo "$plug" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
info "安裝 vim 外掛（第一次大約要一分鐘）"
"$VIM" -N -es -u "$target" -i NONE -c 'PlugInstall --sync' -c 'qa!' || true
[[ -d "$HOME/.vim/plugged/dracula" ]] || fail "外掛沒有裝好，請開 vim 執行 :PlugInstall 看錯誤訊息。"

# 6. 確認 terminal 裡的 vim 是 Homebrew 版，不是不支援 Python 3 的 /usr/bin/vim
login_vim="$(zsh -lc 'command -v vim' 2>/dev/null || true)"
if [[ "$login_vim" != "$VIM" ]]; then
  warn "新開的 terminal 會用 ${login_vim:-（找不到）}，不是 ${VIM}。"
  warn "請連結 repo 的 .zprofile：ln -s $DOTFILES/.zprofile ~/.zprofile"
  warn "或在 ~/.zprofile 加上：eval \"\$(/opt/homebrew/bin/brew shellenv zsh)\""
fi

info "完成！開一個新的 terminal 分頁再執行 vim。"
