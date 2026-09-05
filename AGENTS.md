# AGENTS.md

NixOS + home-manager flake config for a single host (`tardis`, x86_64-linux) with users `doctor` and `guest`, plus one standalone home-manager config (`doctor@arch`) for non-NixOS machines.

## Commands

- Format (enforced style is `nixfmt-rfc-style`): `nix fmt`
- Rebuild system: `sudo nixos-rebuild switch --flake .#tardis`
- Standalone home-manager: `home-manager switch --flake .#doctor@arch`
- Check/eval without applying: `nix flake check` / `nixos-rebuild build --flake .#tardis`
- Reinstall disk (DESTRUCTIVE — wipes /dev/nvme0n1):
  `sudo nix run github:nix-community/disko -- --mode destroy,format,mount --flake .#tardis`

There is no CI and no test suite. `nix fmt` + a successful `nixos-rebuild build` are the verification steps.

## Architecture

- `lib/mkHost.nix` and `lib/mkHome.nix` are the wiring. To add a host/user you must register it in `flake.nix` (`nixosConfigurations` / `homeConfigurations`) AND create `hosts/<name>/` or `users/<name>/`.
- `lib/scanPaths.nix` auto-imports every `.nix` file (and subdir) in a directory, skipping `default.nix`, `meta.nix`, and `home-overrides`. So dropping a new file into `modules/nixos/` or `modules/home/` registers it automatically — no manual import list to update. `modules/*/default.nix` is the aggregator.
- Host metadata lives in `hosts/<host>/meta.nix` (`primaryUser`, `desktopEnvironments`, `displayManager`) and is exposed to modules as the `hostMeta` specialArg (also `hostname`, `inputs`).
- `hosts/<host>/home-overrides/<user>.nix` is auto-included for a user on that host when the file exists (used for per-host home tweaks, e.g. plasma config).
- System modules live in `modules/nixos/`, home-manager modules in `modules/home/`, desktop-specific home modules in `modules/home/desktop/`.
- Module convention: each feature exposes `options.custom.<name>.enable` (via `mkEnableOption`). Enable system features in `hosts/tardis/default.nix`; enable home features per-user in `users/<user>/home.nix`.

## Impermanence (important gotcha)

Root `/` is tmpfs and wiped every reboot; persistent state lives in the `/persist` btrfs subvolume and is bind-mounted back in by `hosts/tardis/impermanence.nix`. If a setting "resets after reboot", the fix is almost always adding its path to `environment.persistence."/persist"` in that file. The ssh host key is in the persist list — losing it would lock sops-nix out of decrypting secrets.

## Secrets (sops-nix)

- Secrets are encrypted in-repo at `secrets/tardis.yaml`; `.sops.yaml` defines the age key rules (admin `doctor` + host `tardis`).
- sops-nix decrypts via `/persist/etc/ssh/ssh_host_ed25519_key` (see `modules/nixos/sops-nix.nix`), which is why that key must persist.
- To edit/add secrets use `sops` (e.g. `sops secrets/tardis.yaml`); new secrets are referenced via `sops.secrets.<name>` / `sops.templates` in the module that consumes them.

## Disk / hardware

- `hosts/tardis/disko.nix` owns all partitioning/formatting/mounting (including the tmpfs root and btrfs subvolumes).
- `hosts/tardis/hardware-configuration.nix` is generated and must not be hand-edited — it no longer declares fileSystems (disko owns them). Put manual hardware tweaks in `hardware-extras.nix`.

## Flake inputs worth knowing

nixpkgs on `nixos-unstable`; `nix-flatpak` is pinned to `?ref=v0.7.0`. `stateVersion` is `"26.05"` (do not bump). Unfree is enabled via `nixpkgs.config.allowUnfree`.
