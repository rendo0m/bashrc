if command -v /usr/local/go/bin/go &> /dev/null; then
  case ${PLATFORM} in
    darwin)
      GOROOT=$(brew --prefix go)
      ;;
    *)
      GOROOT=/usr/local/go
      ;;
  esac

  export GOPATH="${HOME}/GoWorkspace"
  path-append "${HOME}/GoWorkspace/bin"
  path-append "${GOROOT}/bin"
fi
