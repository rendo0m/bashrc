smart-alias() {
# Alias a command with a replacement only if both exist.
  local cmd=${1}
  shift
  local replacement="${@}"

  if command -v "${cmd}" &> /dev/null; then
    alias "${cmd}"="${replacement}"
  fi
}

smart-unalias() {
# Unalias only an existing alias.
  alias_cmd=${1}
  alias | grep -q "${alias_cmd}=" && unalias "${1}";
}
