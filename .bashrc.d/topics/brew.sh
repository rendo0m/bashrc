if [[ "${PLATFORM}" == "darwin" ]]; then

  brew_formulas=${HOME}/.config/brew/formulas
  brew_casks=${HOME}/.config/brew/casks
  brew_taps=${HOME}/.config/brew/taps

  sync-brew() {
    # Install Homebrew if it isn't already
    if ! command -v brew &> /dev/null; then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew doctor

    while read tap <&3; do
      brew tap "${tap}"
    done 3< "${brew_taps}"

    while read formula <&3; do
      brew install "${formula}"
    done 3< "${brew_formulas}"

    while read cask <&3; do
      brew cask install "${cask}"
    done 3< "${brew_casks}"

    brew linkapps
    brew cleanup
    brew prune
  }

  sync-brew-installed() {
    brew tap > "${brew_taps}"
    brew leaves > "${brew_formulas}"
    brew cask list > "${brew_casks}"

    (
      homeshick cd bashrc
      git difftool -- "$(readlink "${brew_taps}")"
      git difftool -- "$(readlink "${brew_formulas}")"
      git difftool -- "$(readlink "${brew_casks}")"
      git commit -av
    )
  }
fi
