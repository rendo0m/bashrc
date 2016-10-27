# Add npm bin to path.
if command -v npm &> /dev/null; then
  source <(npm completion 2>&-)
fi
