# nix-config

doctor's personal NixOS configuration, managed as a Nix flake with Home Manager.

## Overview

This repo builds a single host, `nixos`, combining a NixOS system configuration with a Home Manager configuration for the user `doctor`. It follows a modular layout so system-level and user-level concerns stay separate and each concern lives in its own file.

## Structure

```
.
├── flake.nix                 # Flake inputs/outputs, wires up nixosConfigurations.nixos
├── lib/
│   ├── mkHost.nix            # Helper that builds a nixosSystem + attaches home-manager
│   └── helium.nix            # Shared Helium browser flags/policies (used by both nixos + home modules)
├── hosts/
│   └── nixos/
│       ├── default.nix       # Host-specific config: locale/timezone, user account, stateVersion
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/                # System-level modules
│   │   ├── default.nix       # Imports all nixos modules below
│   │   ├── nix-settings.nix  # Flakes/nix-command, allowUnfree
│   │   ├── boot.nix          # systemd-boot, latest kernel
│   │   ├── networking.nix    # NetworkManager, DNS, firewall
│   │   ├── locale.nix
│   │   ├── desktop.nix       # SDDM + Plasma 6, keyboard layout
│   │   ├── audio.nix         # PipeWire (Pulse/ALSA compatible)
│   │   ├── bluetooth.nix
│   │   ├── printing.nix      # CUPS
│   │   ├── programs.nix      # nh, kdeconnect, neovim, system packages
│   │   ├── browsers.nix      # Managed Chromium/Helium policies (written to /etc)
│   │   └── flatpak.nix       # Enables the Flatpak service
│   └── home/                 # Home Manager modules
│       ├── default.nix       # Imports all home modules below
│       ├── packages.nix      # Misc CLI packages + EDITOR
│       ├── bash.nix          # Bash config, aliases, prompt
│       ├── shell-tools.nix   # starship, fzf, zoxide, bat, eza, ripgrep-all, mcfly
│       ├── git.nix           # Git identity + defaults
│       ├── browser.nix       # Helium browser (flags from lib/helium.nix)
│       ├── flatpak.nix       # Declarative Flatpak app list
│       ├── services.nix      # playerctld
│       └── yt-dlp.nix        # yt-dlp + ffmpeg/aria2/atomicparsley for audio downloads
├── users/
│   └── doctor/
│       └── default.nix       # Home Manager entry point for `doctor`
└── flake.lock
```

## What's included

**System (NixOS)**
- KDE Plasma 6 desktop with SDDM
- PipeWire audio, Bluetooth, printing (CUPS)
- NetworkManager with Cloudflare DNS (1.1.1.1 / 1.0.0.1), stable Wi-Fi MAC, firewall enabled
- `nh` for a nicer `nixos-rebuild` experience, with automatic generation cleanup
- Neovim, KDE Connect, and a small set of system packages (`vim`, `zed-editor`, `ghostty`)
- Flatpak support, plus enterprise policies pushed to Chromium-based browsers (Helium)

**Home (Home Manager, user `doctor`)**
- Shell setup: Bash with history tuning, custom prompt, and `eza`-based `ls` aliases
- Modern CLI tooling: `starship`, `fzf`, `zoxide`, `bat`, `eza`, `ripgrep-all`, `mcfly`
- Git configuration
- Helium browser (via the `oxcl/nix-flake-helium-browser` flake)
- `yt-dlp` configured for high-quality audio-only downloads (metadata/thumbnail embedding, subtitles, `aria2c` as the downloader)
- One declaratively managed Flatpak app (Stremio)
- `playerctld` for media-key/player integration

## Flake inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixos-unstable` |
| `home-manager` | Follows `nixpkgs` |
| `helium-browser` | [`oxcl/nix-flake-helium-browser`](https://github.com/oxcl/nix-flake-helium-browser) |
| `nix-flatpak` | [`gmodena/nix-flatpak`](https://github.com/gmodena/nix-flatpak) |

## Usage

Rebuild the system from the flake (from anywhere, using the flake's path):

```bash
sudo nixos-rebuild switch --flake /home/doctor/Projects/nix-config#nixos
```

Or, since [`nh`](https://github.com/nix-community/nh) is enabled and preconfigured with this flake's path:

```bash
nh os switch
```

Format all Nix files with the repo's configured formatter (`nixfmt-rfc-style`):

```bash
nix fmt
```

Old generations are cleaned up automatically (`nh os` clean policy: keep the last 3 generations, and anything from the last 4 days).

## Adding a new host

`lib/mkHost.nix` is written to support more than one machine. To add one:

1. Create `hosts/<hostname>/default.nix` (and a matching `hardware-configuration.nix`).
2. Add it to `flake.nix`:
   ```nix
   nixosConfigurations = {
     nixos = mkHost { hostname = "nixos"; };
     <hostname> = mkHost { hostname = "<hostname>"; };
   };
   ```
3. Reuse the existing modules under `modules/nixos` and `modules/home`, or add host-specific overrides via `extraModules`.

## Notes

- `time.timeZone` is set to `Asia/Kathmandu`.
- `system.stateVersion` / `home.stateVersion` are pinned to `26.05` — per the NixOS/Home Manager docs, leave these as the version you first installed with rather than bumping them on upgrade.
- Browser policies (password manager off, forced extensions, default search) are defined once in `lib/helium.nix` and consumed by both the NixOS module (writes to `/etc`, required for Chromium-based browsers to pick up managed policies) and the Home Manager module (sets the launch flags).
