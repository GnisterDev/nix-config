user="${USER:-$(id -un)}"
base="${RICE_BASE:-/etc/rice/$user}"
index="$base/home-files/.config/rice/profiles.json"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/rice"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/rice"
flake="${RICE_FLAKE:-$RICE_DEFAULT_FLAKE}"
profiles_dir="$flake/modules/rice/profiles"

die() {
  printf 'rice: %s\n' "$*" >&2
  exit 1
}

notify() {
  notify-send --app-name=rice --icon=preferences-desktop-theme \
    --urgency="${2:-normal}" "rice" "$1" >/dev/null 2>&1 || true
}

need_index() {
  [[ -r $index ]] || die "no profile index at $index (is this a workstation host, and has it been rebuilt?)"
}

names() {
  need_index
  jq -r '.profiles[].name' "$index"
}

default_profile() {
  need_index
  jq -r '.default' "$index"
}

current() {
  if [[ -r $config_dir/active ]]; then
    cat "$config_dir/active"
  else
    default_profile
  fi
}

exists() {
  # No `grep -q`: an early exit would SIGPIPE jq and fail under pipefail.
  names | grep -xF -- "$1" >/dev/null
}

# Truecolor swatches for "#rrggbb" / "rrggbb" arguments.
swatch() {
  local hex
  for hex in "$@"; do
    hex=${hex#\#}
    [[ $hex =~ ^[0-9a-fA-F]{6}$ ]] || continue
    printf '\e[48;2;%d;%d;%dm   \e[0m' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
  done
}

usage() {
  cat <<EOF
rice - switch between desktop profiles

usage:
  rice                       pick a profile with fuzzel (same as 'rice pick')
  rice list                  list profiles with their palettes
  rice current               print the active profile
  rice switch <profile>      switch to a profile (also: rice <profile>)
  rice next | prev           cycle through profiles
  rice new <name> [--from <profile>] [--scheme <base16>] [--edit]
                             create a profile file from an existing one
  rice edit [profile]        open a profile's file in \$EDITOR
  rice schemes [filter]      browse base16 schemes for new profiles
  rice reload                re-apply live bits (notifications, open Neovims)

Profiles live in $profiles_dir (set RICE_FLAKE to use another checkout).
After creating or editing one, rebuild (nh os switch) and switch to it.
EOF
}

reload() {
  # niri also watches its config; this just makes the reload immediate.
  niri msg action load-config-file >/dev/null 2>&1 || true
  makoctl reload >/dev/null 2>&1 || true
  # Running Neovim instances re-read lua/nix.lua and repaint.
  local sock
  for sock in "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/nvim.*.0; do
    [[ -S $sock ]] || continue
    timeout 2 nvim --server "$sock" --remote-expr \
      'luaeval("require([[config.colors]]).apply()")' >/dev/null 2>&1 || true
  done
}

cmd_switch() {
  local name=${1:-}
  [[ -n $name ]] || die "usage: rice switch <profile>"
  exists "$name" || die "unknown profile '$name' (see: rice list)"

  local target="$base"
  [[ $name == "$(default_profile)" ]] || target="$base/specialisation/$name"
  [[ -x $target/activate ]] ||
    die "'$name' is not part of the current generation; rebuild first (nh os switch)"

  mkdir -p "$state_dir"
  exec 9>"$state_dir/lock"
  flock -n 9 || die "another switch is still running"

  printf '%s\n' "$name" >"$state_dir/profile"
  if ! RICE_SKIP_RESTORE=1 "$target/activate" >"$state_dir/activate.log" 2>&1; then
    notify "Switching to $name failed, see $state_dir/activate.log" critical
    die "activation failed, see $state_dir/activate.log"
  fi

  reload
  notify "Switched to $name"
}

cmd_list() {
  need_index
  local cur name polarity description palette
  cur=$(current)
  while IFS=$'\t' read -r name polarity description palette; do
    if [[ $name == "$cur" ]]; then printf '\e[1m▸ '; else printf '  '; fi
    printf '%-18s\e[0m %-6s' "$name" "$polarity"
    # shellcheck disable=SC2086 # palette is a space-separated list
    swatch $palette
    printf '  %s\n' "$description"
  done < <(jq -r '.profiles[]
    | [ .name, .polarity, .description,
        ((.palette // {}) | [.base00, .base01, .base08, .base09, .base0A, .base0B, .base0C, .base0D, .base0E]
          | map(. // "") | join(" ")) ]
    | @tsv' "$index")
}

cmd_pick() {
  need_index
  local cur choice
  cur=$(current)
  choice=$(
    jq -r --arg cur "$cur" \
      '.profiles[] | .name + "  -  " + .description + (if .name == $cur then "  ✓" else "" end)' \
      "$index" | fuzzel --dmenu --prompt "rice ❯ " --width 64
  ) || exit 0
  choice=${choice%%  -  *}
  [[ -z $choice || $choice == "$cur" ]] || cmd_switch "$choice"
}

cmd_cycle() {
  local step=$1 cur i=0 n
  local -a list
  cur=$(current)
  mapfile -t list < <(names)
  n=${#list[@]}
  ((n > 0)) || die "no profiles"
  for i in "${!list[@]}"; do
    [[ ${list[i]} == "$cur" ]] && break
  done
  cmd_switch "${list[(i + step + n) % n]}"
}

cmd_new() {
  local name="" from="" scheme="" edit=0
  while (($#)); do
    case $1 in
      --from) from=${2:?--from needs a profile}; shift 2 ;;
      --scheme) scheme=${2:?--scheme needs a scheme name}; shift 2 ;;
      --edit) edit=1; shift ;;
      -*) die "unknown option $1" ;;
      *)
        [[ -z $name ]] || die "unexpected argument $1"
        name=$1
        shift
        ;;
    esac
  done

  [[ $name =~ ^[a-z][a-z0-9-]*$ ]] ||
    die "profile names use lowercase letters, digits and dashes (got '$name')"
  [[ -d $profiles_dir ]] || die "no $profiles_dir; set RICE_FLAKE to your checkout of this flake"
  from=${from:-$(current)}

  local src="$profiles_dir/$from.nix" dst="$profiles_dir/$name.nix"
  [[ -f $src ]] || die "no profile file $src"
  [[ ! -e $dst ]] || die "$dst already exists"
  if [[ -n $scheme && ! -f $RICE_SCHEMES/$scheme.yaml ]]; then
    die "unknown base16 scheme '$scheme' (see: rice schemes)"
  fi

  sed -e "s/rice\.profiles\.$from\b/rice.profiles.$name/g" \
    -e "s/rice\.active == \"$from\"/rice.active == \"$name\"/g" \
    -e "s/^\([[:space:]]*description = \)\".*\";/\1\"$name (from $from)\";/" \
    "$src" >"$dst"
  if [[ -n $scheme ]]; then
    # New colours: drop any fixed Neovim colorscheme so it follows the palette.
    sed -i -E -e "s|^([[:space:]]*scheme = )\"[^\"]*\";|\1\"$scheme\";|" \
      -e '/^[[:space:]]*nvim\.colorscheme = /d' "$dst"
  fi
  # Flakes only see files git knows about.
  git -C "$flake" add --intent-to-add "$dst" 2>/dev/null || true

  echo "Created $dst (from '$from')."
  echo "Edit it, rebuild with 'nh os switch', then: rice switch $name"
  if ((edit)); then
    exec "${EDITOR:-nvim}" "$dst"
  fi
}

cmd_edit() {
  local name=${1:-$(current)}
  local file="$profiles_dir/$name.nix"
  [[ -f $file ]] || die "no profile file $file"
  exec "${EDITOR:-nvim}" "$file"
}

cmd_schemes() {
  local filter=${1:-} file name
  local -a palette
  [[ -d $RICE_SCHEMES ]] || die "no scheme directory $RICE_SCHEMES"
  for file in "$RICE_SCHEMES"/*.yaml; do
    name=$(basename "$file" .yaml)
    [[ -z $filter || $name == *"$filter"* ]] || continue
    mapfile -t palette < <(
      yq -r '(.palette // .) | [.base00, .base01, .base08, .base09, .base0A, .base0B, .base0C, .base0D, .base0E] | .[]' \
        "$file" 2>/dev/null
    )
    printf '%-40s ' "$name"
    swatch "${palette[@]}"
    printf '\n'
  done
}

subcommand=${1:-pick}
(($#)) && shift
case $subcommand in
  pick) cmd_pick ;;
  list | ls) cmd_list ;;
  current) current ;;
  switch | use) cmd_switch "$@" ;;
  next) cmd_cycle 1 ;;
  prev | previous) cmd_cycle -1 ;;
  new) cmd_new "$@" ;;
  edit) cmd_edit "$@" ;;
  schemes) cmd_schemes "$@" ;;
  reload) reload ;;
  help | -h | --help) usage ;;
  *)
    if exists "$subcommand"; then
      cmd_switch "$subcommand"
    else
      usage >&2
      exit 1
    fi
    ;;
esac
