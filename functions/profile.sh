# Adapted from http://stackoverflow.com/a/20855353/559482 by F. Hauri

profile() {
  # Profile a sourceable script.
  local name="$1"
  shift

  (
    local process="$$"
    exec 3>&2 2> >(
      tee "/tmp/${name}-${process}.log" \
       | gsed -u 's/^.*$/now/' \
       | gdate -f - +%s.%N >"/tmp/${name}-${process}.tim"
    )

    set -x
    source "$@" >/dev/null
    set +x

    exec 2>&3 3>&-
    echo "${name} ${process}"
  )
}

analyze-profile() {
  local name="$1"
  local process="$2"

  paste <(
    while read tim ;do
        [ -z "$last" ] && last=${tim//.} && first=${tim//.}
        crt=000000000$((${tim//.}-10#0$last))
        ctot=000000000$((${tim//.}-10#0$first))
        printf "%12.9f %12.9f\n" ${crt:0:${#crt}-9}.${crt:${#crt}-9} \
                                 ${ctot:0:${#ctot}-9}.${ctot:${#ctot}-9}
        last=${tim//.}
      done < "/tmp/${name}-${process}.tim"
  ) "/tmp/${name}-${process}.log"
}

profile-bashrc() {
   analyze-profile $(profile bashrc ~/.bashrc)
}
