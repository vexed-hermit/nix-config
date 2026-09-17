{ inputs, hostname, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  # TEMP: sops-nix's pkgs/sops-install-secrets/default.nix still requests
  # buildGo125Module, removed from nixpkgs 2026-09-15 (Go 1.25 EOL).
  # Drop once https://github.com/Mic92/sops-nix/pull/984 merges.
  nixpkgs.overlays = [
    (_: prev: {
      buildGo125Module = prev.buildGoModule;
    })
  ];

  sops.defaultSopsFile = ../../secrets/${hostname}.yaml;

  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."wifi-password" = { };

  sops.templates."wifi.env".content = ''
    WIFI_PASSWORD=${config.sops.placeholder."wifi-password"}
  '';
}
