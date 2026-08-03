# Changelog

All notable changes to this configuration are tracked here, newest first.

## 2026-08-03

- Fixed `eza` configuration so it works properly as a drop-in `ls` replacement (aliases in `modules/home/bash.nix`).
- Fixed the `yt-dlp` configuration.
- Added `yt-dlp` module (`modules/home/yt-dlp.nix`) — audio-only extraction via `ffmpeg`, `aria2c` as the downloader, subtitle and metadata embedding, download archive tracking.

## 2026-08-02

- Modularized the entire configuration into `modules/nixos/*` and `modules/home/*`, each imported via a `default.nix`.
- Compartmentalized Helium browser config into a shared `lib/helium.nix` (flags + policies), consumed by both the NixOS module (`modules/nixos/browsers.nix`) and the Home Manager module (`modules/home/browser.nix`).
- Applied `nix fmt` formatting across the repo.
- Added the Helium browser to the home configuration and did initial Bash configuration.
- Switched DNS to Cloudflare (`1.1.1.1` / `1.0.0.1`) in `modules/nixos/networking.nix`.
- Removed Firefox; added `nh` (Nix helper) and the `zip`/`unzip` packages.

## 2026-07-31

- Added `gmodena/nix-flatpak` as a flake input and declared the Stremio Flatpak package.
- Added `bat` as an available package/option.
- Enabled `ripgrep-all`, `fzf`, `zoxide`, and `mcfly`.
- Enabled `services.playerctld`.
- Added `bat` and `wl-clipboard` to home packages.
- Created `lib/mkHost.nix` to modularize NixOS host creation (`mkHost` helper used by `flake.nix`).

## 2026-07-30

- Renamed Git identity options from `programs.git.userEmail`/`userName` to `programs.git.settings.user.email`/`name`.
- Added the `tree` package.
- Initial commit: base NixOS + Home Manager flake for host `nixos`, user `doctor`.

---

*This file is maintained by hand alongside the git history — see `git log` for the exact commit-level record.*
