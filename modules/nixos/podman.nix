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

    # Belt-and-braces: dockerSocket.enable is documented as requiring group
    # "podman" to connect, but pin it explicitly so a future nixpkgs default
    # change can't silently leave the socket root:root and reintroduce the
    # need for sudo.
    systemd.sockets.podman.socketConfig = {
      SocketGroup = "podman";
      SocketMode = "0660";
    };

    # Needed so the primary user can talk to the Docker-compat socket without sudo.
    # Note: "podman" group membership is effectively root-equivalent, same caveat
    # as the "docker" group — it's what lets a user manage/attach to any container.
    users.users.${config.hostSettings.primaryUser}.extraGroups = [ "podman" ];

    # oci-containers (used by hermes-agent.nix etc.) runs containers as root
    # via the system podman service, into root's own container storage — a
    # separate storage tree from the primary user's rootless podman. Without
    # this, plain `podman exec`/`podman ps` as the primary user look in the
    # wrong (empty) storage and only `sudo podman ...` finds anything.
    # Pointing CONTAINER_HOST at the docker-compat socket makes the podman
    # CLI itself go through that socket instead, so root-owned containers
    # show up and `podman exec -it <container> ...` works without sudo, as
    # long as the invoking user is in the "podman" group above.
    environment.sessionVariables = {
      CONTAINER_HOST = "unix:///run/podman/podman.sock";
    };

    environment.systemPackages = with pkgs; [
      podman-tui     # optional terminal UI for containers
      dive           # inspect image layers
      docker-compose
    ];
  };
}
