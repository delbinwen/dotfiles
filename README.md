# dotfiles

我的 macOS（Apple Silicon）設定檔。每個檔案都是用 symlink 連到 home 目錄，例如 `~/.vimrc -> ~/Work/Code/dotfiles/.vimrc`。

| 檔案 | 用途 |
|---|---|
| `.vimrc` | Vim 設定，用 vim-plug 管理外掛 |
| `.zshenv` | 所有 zsh 都會載入（包含 script），只放 PATH 這類輕量設定 |
| `.zprofile` | 登入 shell 載入：Homebrew、OrbStack |
| `.zshrc` | 互動 shell 設定：Zinit 外掛、alias、函式 |
| `.zshrc.local` | 每台電腦不同的設定，由 `.zshrc` 載入 |
| `.p10k.zsh` | Powerlevel10k 提示列設定 |

## 在新電腦設定 Vim

```sh
xcode-select --install          # git、curl、make
# 照 https://brew.sh 安裝 Homebrew
git clone https://github.com/delbinwen/dotfiles.git ~/Work/Code/dotfiles
~/Work/Code/dotfiles/setup-vim.sh
```

`setup-vim.sh` 會做這些事，重複執行也沒關係：

1. 用 Homebrew 安裝 `vim`、`ripgrep`、`universal-ctags`、`flake8`
2. 安裝 Homebrew vim 需要的 Python 版本（UltiSnips、jedi-vim 要用）
3. 把 `~/.vimrc` 連到這個 repo（原本的檔案會備份成 `~/.vimrc.bak.<時間>`）
4. 下載 vim-plug，安裝所有外掛

腳本只連結 `.vimrc`。zsh 的設定檔也要連結，尤其是 `.zprofile`，它會把 Homebrew 加到 PATH，這樣 terminal 才會用 Homebrew 的 vim，而不是 macOS 內建、不支援 Python 3 的 `/usr/bin/vim`：

```sh
cd ~/Work/Code/dotfiles
for f in .zshenv .zprofile .zshrc .zshrc.local .p10k.zsh; do ln -s "$PWD/$f" ~/"$f"; done
```

全部完成後**開一個新的 terminal 分頁**再執行 `vim`。如果 PATH 沒設好，腳本最後會提醒你。

### 常見問題

- **出現 `UltiSnips: Python 3 is not available`**：Homebrew 升級 vim 後，它可能改用新版 Python。再跑一次 `setup-vim.sh` 就會裝上對應版本。
- **新增或移除外掛**：改完 `.vimrc` 後，在 vim 裡執行 `:PlugInstall` 或 `:PlugClean`。
- **更新外掛**：`:PlugUpdate`
- **不要執行 `:VimBootstrapUpdate`**：它會用 vim-bootstrap 的範本重新產生 `.vimrc`，蓋掉這裡的修改。
- **只想在某台電腦加設定或外掛**：寫在 `~/.vimrc.local` 或 `~/.vimrc.local.bundles`，`.vimrc` 會自動載入，不需要放進 repo。

## Vim 常用快捷鍵

Leader 鍵是空白鍵，下表用 `␣` 表示，例如 `␣e` 是先按空白鍵再按 `e`。新增快捷鍵時，不要讓一個快捷鍵剛好是另一個的開頭（例如同時有 `␣g` 和 `␣gs`），否則按短的那個時 vim 會等 1 秒。

| 按鍵 | 功能 |
|---|---|
| `jk` | 插入模式下回到一般模式 |
| **檔案與搜尋** | |
| `F3` / `F2` | 開關檔案樹 / 在檔案樹中定位目前檔案 |
| `F4` | 開關 Tagbar（函式、類別列表） |
| `␣e` | 用 fzf 找檔案 |
| `␣b` | 用 fzf 切換已開啟的 buffer |
| `␣y` | 用 fzf 搜尋指令歷史 |
| `␣f` | 用 ripgrep 搜尋專案內容（輸入要找的文字後按 Enter） |
| `␣␣` | 清除搜尋高亮 |
| **視窗、分頁、buffer** | |
| `␣h` / `␣v` | 水平 / 垂直分割視窗 |
| `Ctrl-h/j/k/l` | 在視窗之間移動 |
| `Tab` / `Shift-Tab` | 下一個 / 上一個分頁 |
| `Shift-t` | 開新分頁 |
| `␣x` / `␣z` | 下一個 / 上一個 buffer |
| `␣c` | 關閉 buffer |
| `␣sh` | 開啟 terminal |
| **編輯** | |
| `gcc` / `gc`（選取後） | 註解或取消註解 |
| `J` / `K`（選取後） | 把選取的行往下 / 往上移 |
| `Tab`（插入模式） | 展開 snippet、跳到下一個欄位；`Ctrl-b` 跳回上一個 |
| `y` / `p` | 直接複製到 / 貼上自系統剪貼簿 |
| `:FixWhitespace` | 刪除行尾空白 |
| **Git（fugitive）** | |
| `␣gs` | Git 狀態 |
| `␣ga` | `git add` 目前檔案 |
| `␣gc` | commit |
| `␣gp` / `␣gl` | push / pull |
| `␣gb` | blame |
| `␣gd` | 左右對照目前檔案還沒 `git add` 的修改 |
| `␣o` | 在 GitHub 開啟目前這一行 |
| `]c` / `[c` | 跳到下一個 / 上一個修改區塊 |
| `␣ghs` / `␣ghu` / `␣ghp` | 暫存 / 復原 / 預覽游標所在的修改區塊 |
| **Python（jedi-vim）** | |
| `␣d` | 跳到定義 |
| `␣a` | 跳到賦值的地方 |
| `␣n` | 列出所有使用處 |
| `␣r` | 重新命名 |
| `K` | 查看文件 |
| `Ctrl-Space` | 自動完成 |
