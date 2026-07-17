# .zshenv — sourced for ALL zsh shells (interactive, non-interactive, login, script)
# Keep this file fast and side-effect-free.

# Node.js: resolve nvm default version and add its bin to PATH so
# non-interactive shells (git hooks, language servers, CI scripts) can find node/npm/npx.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/alias/default" ]]; then
  _nvm_alias=$(< "$NVM_DIR/alias/default")
  # Handles partial aliases like "24" or full "v24.14.0"
  _nvm_node=$(command ls "$NVM_DIR/versions/node" 2>/dev/null \
    | command grep "^v${_nvm_alias#v}" \
    | command sort -V \
    | command tail -1)
  [[ -n "$_nvm_node" ]] && export PATH="$NVM_DIR/versions/node/$_nvm_node/bin:$PATH"
  unset _nvm_alias _nvm_node
fi
