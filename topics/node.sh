# Add npm bin to path.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
if command -v npm &> /dev/null; then
  source <(npm completion 2>&-)
fi
