#
# This shell prompt config file was created by promptline.vim
#

function __promptline_last_exit_code {
  local clean_symbol="✔"
  local green_fg="${wrap}38;5;46${end_wrap}"
  if [ $last_exit_code -gt 0 ]; then
    printf "${warn_fg}$last_exit_code${space}${sep_fg}${sep}"
  else
    printf "${green_fg}$clean_symbol${space}${sep_fg}${sep}"
  fi
}

function __promptline_ps1 {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  #VIRTUAL_ENV
  __promptline_wrapper "${sep_fg}${fsep}${space}${VIRTUAL_ENV##*/}"

  # Non-Zero Exit Code Warning
  __promptline_wrapper \
    "$(__promptline_last_exit_code)" 
    
  # section "a" header
  slice_prefix="${a_fg}${space}"
  slice_suffix="${space}${a_sep_fg}"
  slice_joiner="${sep_fg}${alt_sep}${space}"
  slice_empty_prefix="${a_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices

  # CWD + Jobs
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
  __promptline_wrapper "$(__promptline_jobs)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${sep_fg}${sep}${space}${b_fg}"
  slice_suffix="$space${b_sep_fg}"
  slice_joiner="${b_fg}${alt_sep}${space}"
  slice_empty_prefix="${b_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices

  # Username
  __promptline_wrapper "$(if [[ ${EUID} == 0 ]]; then echo ${warn_fg}'\u'; else echo '\u'; fi)${b_fg} @ \h"  "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${sep_fg}${sep}${space}${c_fg}"
  slice_suffix="${space}${c_sep_fg}"
  slice_joiner="${sep_fg}${alt_rsep}${space}"
  slice_empty_prefix="${c_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices

  # Git Branch
  __promptline_wrapper \
    "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix"  \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # Git Status
  __promptline_wrapper \
    "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "x" header
  slice_prefix="${x_fg}${space}"
  slice_suffix="$space${x_sep_fg}"
  slice_joiner="${x_fg}${alt_sep}${space}"
  slice_empty_prefix="${x_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "x" slices

  # Hostname if SSH'd into another host
  __promptline_wrapper "$([[ -n ${ZSH_VERSION-} ]] \
    && print %m || { [[ -n ${SSH_CLIENT} ]] \
    && printf " %s" \\h; })" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "d" header
  slice_prefix="${sep_fg}${sep}${space}${d_fg}"
  slice_suffix="$space${d_sep_fg}"
  slice_joiner="${d_fg}${alt_sep}${space}"
  slice_empty_prefix="${d_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "d" slices

  # List Dir ... this shell with grep 1:
  __promptline_wrapper "$(ls -1 | wc -l) files,$(ls -lah | grep -m 1 'total\|insgesamt' | sed -r 's/(1:total|1:insgesamt)//')" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }


  # Break for second line
  # close first line section
  printf "${sep_fg}${esep}"
  is_prompt_empty=1

  # close sections
  printf "%s" "${sesep}${reset}${space}"
}

function __promptline_vcs_branch {
  local branch
  local branch_symbol=" "

  # git
  if hash git 2>/dev/null; then
    if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
      branch=${branch##*/}
      printf "%s" "${branch_symbol}${branch:-unknown}"
      return
    fi
  fi
  return 1
}

function __promptline_cwd {
  local dir_limit="3"
  local truncation="${space}⋯"
  local first_char
  local part_count=0
  local formatted_cwd=""
  local dir_sep="/"

  local cwd

  if [[ "${PLATFORM}" == 'darwin' ]]; then
    cwd="${PWD/#$HOME/\~}"
  else
    cwd="${PWD/#$HOME/~}"
  fi

  # get first char of the path, i.e. tilde or slash
  #[[ -n ${ZSH_VERSION-} ]] && first_char="$cwd[1,1]" || first_char=${cwd::1}

  # remove leading tilde
  cwd="${cwd#\~}"

  while [[ "$cwd" == */* && "$cwd" != "/" ]]; do
    [[ $part_count -eq $dir_limit ]] && first_char="$truncation" && break
    # pop off last part of cwd
    local part="${cwd##*/}"
    cwd="${cwd%/*}"

    formatted_cwd="$dir_sep$part$formatted_cwd"
    part_count=$((part_count+1))
  done

  printf "%s" "$first_char$formatted_cwd"
}

function __promptline_left_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # section "a" header
  slice_prefix="${sep}${a_fg}${space}"
  slice_suffix="$space${a_sep_fg}"
  slice_joiner="${a_fg}${alt_sep}${space}"
  slice_empty_prefix="${a_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "a" slices
  __promptline_wrapper \
    "$([[ -n ${ZSH_VERSION-} ]] && print "%m" \
    || printf "%s" \\h)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "b" header
  slice_prefix="${sep}${b_fg}${space}"
  slice_suffix="$space${b_sep_fg}"
  slice_joiner="${b_fg}${alt_sep}${space}"
  slice_empty_prefix="${b_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "b" slices
  __promptline_wrapper "\u" "$slice_prefix" "$slice_suffix" && \
    { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # section "c" header
  slice_prefix="${sep}${c_fg}${space}"
  slice_suffix="$space${c_sep_fg}"
  slice_joiner="${c_fg}${alt_sep}${space}"
  slice_empty_prefix="${c_fg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  # section "c" slices
  __promptline_wrapper "${VIRTUAL_ENV##*/}" "$slice_prefix" "$slice_suffix" && \
    { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # close sections
  printf "%s" "${sep}$reset$space"
}

function __promptline_wrapper {
  # wrap the text in $1 with $2 and $3, only if $1 is not empty
  # $2 and $3 typically contain non-content-text, like color escape codes and separators

  [[ -n "$1" ]] || return 1
  printf "%s" "${2}${1}${3}"
}

function __promptline_git_status {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

  local added_symbol="●"
  local unmerged_symbol="✖"
  local modified_symbol="✚"
  local clean_symbol="✔"
  local has_untracked_files_symbol="…"

  local ahead_symbol="↑"
  local behind_symbol="↓"

  local unmerged_count=0
  local modified_count=0
  local has_untracked_files=0
  local added_count=0
  local is_clean=""

  local black_fg="${wrap}38;5;0${end_wrap}"
  local red_fg="${wrap}38;5;1${end_wrap}"
  local green_fg="${wrap}38;5;46${end_wrap}"
  local yellow_fg="${wrap}38;5;3${end_wrap}"
  local blue_fg="${wrap}38;5;4${end_wrap}"
  local magenta_fg="${wrap}38;5;5${end_wrap}"
  local cyan_fg="${wrap}38;5;6${end_wrap}"
  local white_fg="${wrap}38;5;7${end_wrap}"

  set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  local behind_count=$1
  local ahead_count=$2

  # Added    (A), Copied  (C), Deleted (D),
  # Modified (M), Renamed (R), changed (T),
  # Unmerged (U), Unknown (X), Broken  (B)
  while read line; do
    case "$line" in
      M*) modified_count=$(( $modified_count + 1 )) ;;
      U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(( $added_count + 1 )) ;;
    esac
  done < <(git diff --name-status --cached)

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    has_untracked_files=1
  fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
    is_clean=1
  fi

  local leading_whitespace=""
  [[ $ahead_count -gt 0 ]] && {
    printf "%s" "$cyan_fg$leading_whitespace$ahead_symbol$ahead_count$x_fg"
    leading_whitespace=" "
  }

  [[ $behind_count -gt 0 ]] && {
    printf "%s" "$magenta_fg$leading_whitespace$behind_symbol$behind_count$x_fg"
    leading_whitespace=" "
  }

  [[ $modified_count -gt 0 ]] && {
    printf "%s" "$yellow_fg$leading_whitespace$modified_symbol$modified_count$x_fg"
    leading_whitespace=" "
  }

  [[ $unmerged_count -gt 0 ]] && {
    printf "%s" "$magenta_fg$leading_whitespace$unmerged_symbol$unmerged_count$x_fg"
    leading_whitespace=" "
  }

  [[ $added_count -gt 0 ]] && {
    printf "%s" "$blue_fg$leading_whitespace$added_symbol$added_count$x_fg"
    leading_whitespace=" "
  }

  [[ $has_untracked_files -gt 0 ]] && {
    printf "%s" "$yellow_fg$leading_whitespace$has_untracked_files_symbol$x_fg"
    leading_whitespace=" "
  }

  [[ $is_clean -gt 0 ]]  && {
    printf "%s" "$leading_whitespace$green_fg$clean_symbol$x_fg"
    leading_whitespace=" "
  }
}

function __promptline_right_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix

  # section "warn" header
  slice_prefix="${warn_sep_fg}${rsep}${warn_fg}${space}"
  slice_suffix="$space${warn_sep_fg}"
  slice_joiner="${warn_fg}${alt_rsep}${space}"
  slice_empty_prefix=""
  # section "warn" slices
  __promptline_wrapper
    "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; }

  # section "x" header
  slice_prefix="${x_sep_fg}${rsep}${x_fg}${space}"
  slice_suffix="$space${x_sep_fg}"
  slice_joiner="${x_fg}${alt_rsep}${space}"
  slice_empty_prefix=""
  # section "x" slices
  __promptline_wrapper \
    "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper \
    "$(__promptline_git_status)" "$slice_prefix" "$slice_suffix"\
    && { slice_prefix="$slice_joiner"; }

  # section "y" header
  slice_prefix="${y_sep_fg}${rsep}${y_fg}${space}"
  slice_suffix="$space${y_sep_fg}"
  slice_joiner="${y_fg}${alt_rsep}${space}"
  slice_empty_prefix=""
  # section "y" slices
  __promptline_wrapper \
    "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; }
  __promptline_wrapper \
    "$(__promptline_jobs)" "$slice_prefix" "$slice_suffix" \
    && { slice_prefix="$slice_joiner"; }

  # close sections
  printf "%s" "$reset"
}

function __promptline_jobs {
  local job_count=0

  local IFS=$'\n'
  for job in $(jobs); do
    # count only lines starting with [
    if [[ $job == \[* ]]; then
      job_count=$(($job_count+1))
    fi
  done

  [[ $job_count -gt 0 ]] || return 1;
  printf "%s" "$job_count"
}

function __promptline {
  local last_exit_code="$?"

  local esc=$'[' end_esc=m
  if [[ -n ${ZSH_VERSION-} ]]; then
    local noprint='%{' end_noprint='%}'
  else
    local noprint='\[' end_noprint='\]'
  fi
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local space=" "
 
  local sep_fg="${wrap}38;5;123${end_wrap}"

  local warn_fg="${wrap}38;5;196${end_wrap}"
  local warn_sep_fg="${wrap}38;5;52${end_wrap}"
 
  local sep="ǁ"
  local esep="ǁ═╗\n${space}╚═"
  local fsep="\n${space}╔ǁ"
  local sesep="$(if [ ${EUID} -eq 0 ]; then echo ${warn_fg}»; else echo ${sep_fg}»; fi)" 
  
  local rsep=""
  local alt_sep="ǁ"
  local alt_rsep=""
  
  local reset="${wrap}0${end_wrap}"

  local a_fg="${wrap}38;5;7${end_wrap}"
  local a_sep_fg="${wrap}38;5;10${end_wrap}"

  local b_fg="${wrap}38;5;27${end_wrap}"
  local b_sep_fg="${wrap}38;5;4${end_wrap}"

  local c_fg="${wrap}38;5;196${end_wrap}"
  local c_sep_fg="${wrap}38;5;2${end_wrap}"

  local d_fg="${wrap}38;5;10${end_wrap}"
  local d_sep_fg="${wrap}38;5;2${end_wrap}"

  local x_fg="${wrap}38;5;14${end_wrap}"
  local x_sep_fg="${wrap}38;5;0${end_wrap}"

  local y_fg="${wrap}38;5;7${end_wrap}"
  local y_sep_fg="${wrap}38;5;10${end_wrap}"

  if [[ -n ${ZSH_VERSION-} ]]; then
    PROMPT="$(__promptline_left_prompt)"
    RPROMPT="$(__promptline_right_prompt)"
  else
    PS1="$(__promptline_ps1)"
  fi
}

if [[ -n ${ZSH_VERSION-} ]]; then
  if [[ ! ${precmd_functions[(r)__promptline]} == __promptline ]]; then
    precmd_functions+=(__promptline)
  fi
else
  if [[ ! "$PROMPT_COMMAND" == *__promptline* ]]; then
    PROMPT_COMMAND='__promptline;'$'\n'"$PROMPT_COMMAND"
  fi
fi
