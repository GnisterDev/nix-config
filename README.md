# nixos

Four machines, one flake, written in the
[dendritic pattern](https://import-tree.denful.dev/guides/dendritic/):
every `.nix` file under `hosts/` and `modules/` is a flake-parts module,
imported automatically by [import-tree](https://github.com/vic/import-tree).
Files and directories starting with `_` are skipped.

| Host      | Role                         | Aspects                                                       |
| --------- | ---------------------------- | ------------------------------------------------------------- |
| `wsl`     | Windows laptop, Linux dev    | base · dev · wsl                                              |
| `laptop`  | School / work                | base · dev · metal · workstation · laptop                     |
| `desktop` | Gaming / work                | base · dev · metal · workstation · gaming · creative · virtualisation |
| `server`  | Services / storage           | base · metal · server · postgresql · jellyfin · syncthing · forgejo · immich · samba |

## How it fits together

A **feature file** contributes to one or more **aspects**: named modules
stored in `flake.modules.nixos.<aspect>` and `flake.modules.homeManager.<aspect>`.
Many files contribute to the same aspect, and their contents merge.

```nix
# modules/workstation/audio.nix
{
  flake.modules.nixos.workstation = { services.pipewire.enable = true; /* ... */ };
  flake.modules.homeManager.workstation = { pkgs, ... }: { home.packages = [ pkgs.pavucontrol ]; };
}
```

A **host** picks aspects:

```nix
# hosts/laptop/default.nix
configurations.nixos.laptop.module = {
  imports = with config.flake.modules.nixos; [ base dev metal workstation laptop ];
};
```

Two rules do the wiring (`modules/flake/`):

- `configurations.nixos.<host>.module` becomes `nixosConfigurations.<host>`.
- A host that imports `nixos.<aspect>` automatically loads
  `homeManager.<aspect>` for its user. There is no `sharedModules` bookkeeping.

There are no `specialArgs`. A file that needs flake inputs or shared
constants closes over them from its own top-level arguments
(`{ inputs, config, ... }:`). Shared values live in `config.constants`
(`modules/flake/constants.nix`).

To **add something**, create a file in the directory of the aspect it
belongs to. To **remove** it, delete the file. New files must be tracked by
git (`git add`) before the flake can see them.

| Aspect           | What it is                                                                 |
| ---------------- | -------------------------------------------------------------------------- |
| `base`           | Nix/flakes, Home Manager, user, zsh + starship, core CLI, git/gh/lazygit, direnv, nh, Neovim, tmux, SSH, sops |
| `dev`            | Toolchains (clang, cmake, ninja, python/uv, node/pnpm, rust, go, java), language servers, nix-ld |
| `wsl`            | NixOS-WSL, Windows ssh-agent bridge                                        |
| `metal`          | Physical machines: GRUB (EFI, os-prober), firmware/fwupd, sensors/SMART    |
| `workstation`    | niri, greetd, PipeWire, Bluetooth, NetworkManager, fonts, the desktop apps, **rice profiles** |
| `laptop`         | thermald, idle/suspend timings, lid handling, TPM2 + systemd initrd        |
| `gaming`         | Steam/Proton-GE, GameMode, Gamescope, MangoHud, Lutris, Heroic, Wine       |
| `creative`       | OBS, Blender, Krita, GIMP, Inkscape, Kdenlive, Audacity, ffmpeg            |
| `virtualisation` | libvirt/QEMU + virt-manager                                                |
| `server`         | nftables, Tailscale, Podman, Caddy, Prometheus + Grafana                   |
| opt-in           | `secure-boot` (lanzaboote), `emulation`, `backup` (restic), `tailscale`    |

## Rice profiles (desktop visual identities)

The laptop and desktop have switchable **profiles**: a colour scheme,
wallpaper, fonts, cursor, icons, gaps, corner radius, borders and bar layout.
Each one is a single file in [`modules/rice/profiles/`](modules/rice/profiles).

| Profile          | Look                                                                       |
| ---------------- | -------------------------------------------------------------------------- |
| `mocha`          | Catppuccin Mocha: floating rounded islands, gradient focus ring, blurred colour blobs |
| `gruvbox`        | Warm retro: square corners, thick inside border, docked bottom bar, no shadows |
| `rose-pine-dawn` | Light: wide gaps, big radii, minimal text-only bar                          |
| `nord`           | Frosted: translucent everything, dimmed inactive windows, floating bottom bar |

### Switching

| Action           | How                                                                        |
| ---------------- | -------------------------------------------------------------------------- |
| Pick from a menu | `Mod+Shift+T`, or click the brush in the bar                               |
| Next profile     | `Mod+Ctrl+T`, or scroll on the brush                                       |
| Terminal         | `rice list`, `rice switch nord`, `rice nord`, `rice next`                  |

Switching takes about a second and needs no rebuild and no network. Every
profile is already built into the current generation as a Home Manager
*specialisation*, so `rice` only runs that specialisation's activation.
niri reloads its config, waybar and the wallpaper restart (with an animated
transition), mako reloads, and open Neovim windows repaint. New terminals and
apps pick up the new theme; already-running ones keep the old one.

Your choice is remembered (`~/.local/state/rice/profile`) and survives
rebuilds and reboots. `workstation.profile` in the host file only sets the
starting point.

### Making a new one

```sh
rice schemes            # browse the ~300 base16 schemes, with colour swatches
rice schemes tokyo      # ...filtered

rice new tokyo --from nord --scheme tokyo-night-dark --edit
nh os switch            # build it into the generation
rice switch tokyo
```

`rice new` copies an existing profile file, renames it, swaps the scheme and
`git add`s it. A profile is mostly data:

```nix
rice.profiles.tokyo = {
  description = "Tokyo Night · ...";   # shown in the picker
  polarity = "dark";                   # or "light"
  scheme = "tokyo-night-dark";         # base16 name, YAML path, attrset, or null
  accent = "base0D";                   # focus ring, active workspace
  accent2 = "base0E";                  # gradient end, rice indicator

  wallpaper.image = ../../../assets/wallpapers/city.jpg;  # or generate one:
  wallpaper.generate = "blobs";        # solid | gradient | radial | blobs
  wallpaper.colors = [ "base00" "base0D" "base0E" "base0C" ];
  wallpaper.transition = "grow";       # awww transition

  fonts.mono = { name = "JetBrainsMono Nerd Font"; package = pkgs.nerd-fonts.jetbrains-mono; };
  fonts.sans = { name = "Inter"; package = pkgs.inter; };
  cursor = { name = "Bibata-Modern-Ice"; package = pkgs.bibata-cursors; };

  gaps = 8;  radius = 10;
  border = { kind = "ring"; width = 2; gradient = false; };  # ring = outside, border = inside
  shadow = true;
  opacity = { terminal = 0.9; bar = 0.85; popups = 0.95; inactive = 0.95; };
  bar = { style = "islands"; position = "top"; height = 34; };  # islands | docked | minimal
  lock.blur = true;                    # blurred screenshot vs wallpaper
  nvim.colorscheme = null;             # null = paint Neovim from the palette
};
```

Every option has a default. The full list, with descriptions, is in
[`modules/rice/engine.nix`](modules/rice/engine.nix). With `scheme = null`
and a `wallpaper.image`, Stylix derives the palette from the image.

For anything the options don't cover, use the escape hatch shown in
[`gruvbox.nix`](modules/rice/profiles/gruvbox.nix): a `lib.mkIf
(config.rice.active == "<name>")` block, applied only while that profile is
active.

To experiment with niri live, create `~/.config/niri/local.kdl`. It is
included last and reloaded on save, with no rebuild needed.

### What renders what

| File                    | Turns the active profile into                                  |
| ----------------------- | -------------------------------------------------------------- |
| `rice/engine.nix`       | Profile options, Stylix (GTK, Qt, foot, fuzzel, mako, btop, bat, yazi, zathura, …), one specialisation per profile, restore hook |
| `rice/niri.nix`         | `rice.kdl`: gaps, focus ring / border, shadows, corner radius, cursor |
| `rice/waybar.nix`       | Bar modules, position and the three bar styles                 |
| `rice/wallpaper.nix`    | Image or generated wallpaper, painted by awww                   |
| `rice/surfaces.nix`     | Launcher/notification shapes, terminal padding, lock screen, power menu, Neovim palette |
| `rice/cli.nix`, `rice.sh` | The `rice` command                                            |

## Neovim

Plugins are managed by lazy.nvim, but they come from nixpkgs. lazy finds
them through `dev.path`, so nothing is downloaded at runtime and versions
follow `flake.lock`. All tree-sitter grammars are prebuilt as well. A plugin
spec that isn't in the Nix list in
[`modules/editor/neovim.nix`](modules/editor/neovim.nix) falls back to a git
download, which is handy for trying something before adding it.

Language servers come from Nix (`modules/dev/language-servers.nix`) rather than
Mason. Each one is only enabled when its binary is on PATH, so the same
config works on the server.

The Lua lives in `modules/editor/nvim/`. Its config is read-only (it's in the
Nix store), so edit it in the repo and rebuild.

## Bootstrapping

Clone the repo to `~/nixos` on every machine. That path is
`constants.flakeDir`, used by `nh` and by `rice new`.

**wsl** (from the current NixOS-WSL install; it also renames the default user to `gnister`):

```sh
nix-shell -p git --run 'git clone <repo> ~/nixos'
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild boot --flake ~/nixos#wsl
# then from PowerShell: wsl -t NixOS; wsl -d NixOS --user root exit; wsl -t NixOS
```

After that first switch flakes are enabled permanently, and the clone in
`/home/nixos` can be moved to `/home/gnister/nixos`.

**laptop / desktop / server** (from the NixOS installer, after partitioning and mounting at `/mnt`):

```sh
nixos-generate-config --root /mnt --show-hardware-config > hosts/<host>/_hardware.nix
git add hosts/<host>/_hardware.nix
sudo nixos-install --flake .#<host>
sudo nixos-enter --root /mnt -c 'passwd gnister'
```

The desktop and server `_hardware.nix` files are placeholders until you do
this. Day to day, `nh os switch` (alias `nb`) rebuilds, and
`nh os switch --update` (alias `nup`) updates the inputs as well.

### Secrets

sops-nix with age. System secrets use the host's SSH key, so convert each
host's key once and add it to `.sops.yaml`:

```sh
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
sops updatekeys secrets/secrets.yaml
```

The restic `backup` aspect needs `restic/password` and `restic/repository`
in `secrets/secrets.yaml` before you import it (see
`modules/server/backup.nix`).

### Server notes

Services sit behind Caddy at `<name>.home.arpa` (jellyfin, git, photos,
grafana) with Caddy's local CA. Point DNS at the server (router, Tailscale
split DNS, or `/etc/hosts`) and trust the CA, or change `constants.domain`
to a real domain. The Syncthing UI is reached through
`ssh -L 8384:127.0.0.1:8384 server`.

## Checks

```sh
nix flake check   # evaluates all four hosts + statix/deadnix lint
nix develop       # nixfmt, statix, deadnix, nil, sops, age
```
