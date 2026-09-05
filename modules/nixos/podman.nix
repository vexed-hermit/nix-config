{ lib, config, pkgs, ... }:

let
  cfg = config.custom.podman;
in
{
  options.custom.podman.enable = lib.mkEnableOption "Podman rootless containers (with Docker CLI compatibility)";

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;              # provides a `docker` alias/socket that points at podman
      dockerSocket.enable = true;       # expose a Docker-compatible socket for tools that expect it
      defaultNetwork.settings.dns_enabled = true;
    };

    # Needed so the primary user can talk to the Docker-compat socket without sudo.
    # Note: "podman" group membership is effectively root-equivalent, same caveat
    # as the "docker" group — it's what lets a user manage/attach to any container.
    users.users.${config.hostSettings.primaryUser}.extraGroups = [ "podman" ];

    environment.systemPackages = with pkgs; [
      podman-tui     # optional terminal UI for containers
      dive           # inspect image layers
      docker-compose
    ];
  };
}
