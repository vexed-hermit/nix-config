{ lib, config, pkgs, ... }:

let
  cfg = config.custom.hermesAgent;

  # Bind-mounted into /opt/data in both containers — the upstream image's
  # single source of truth for config.yaml, .env, sessions/, memories/,
  # skills/, etc. Already in hosts/tardis/impermanence.nix.
  dataDir = "/var/lib/hermes";

  # provider = "custom" only auto-detects OPENAI_API_KEY by default; since
  # the secret is named NANO_GPT_API_KEY, point at it explicitly. ${...}
  # here is resolved by Hermes at runtime from its own process environment
  # (populated below via environmentFiles), not by Nix — hence the escape.
  apiKeyPlaceholder = "\${NANO_GPT_API_KEY}";
in
{
  options.custom.hermesAgent = {
    enable = lib.mkEnableOption "Hermes Agent (NousResearch), run via the official Docker image on podman";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/nousresearch/hermes-agent:latest";
      description = ''
        Container image reference. Consider pinning a release tag (e.g.
        "docker.io/nousresearch/hermes-agent:v2026.6.19") instead of
        ":latest" so rebuilds don't silently change what's running.
      '';
    };

    model = lib.mkOption {
      type = lib.types.str;
      default = "z-ai/glm-5.3:thinking";
      description = ''
        Model ID as NanoGPT expects it (NanoGPT is OpenAI-compatible and
        prefixes model IDs with their upstream provider, e.g.
        "openai/gpt-5.2" or "anthropic/claude-opus-4.5").
      '';
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://nano-gpt.com/api/v1";
      description = ''
        Custom OpenAI-compatible endpoint Hermes' main model routes through.
      '';
    };

    uid = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      description = ''
        UID the image's internal "hermes" user is remapped to at startup
        (HERMES_UID). ${dataDir} is chowned to this so files the container
        creates stay owned by something sane on the host.
      '';
    };

    gid = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      description = "GID counterpart to `uid` (HERMES_GID).";
    };

    dashboard.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Also run the web dashboard container, bound to 127.0.0.1 only.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "podman";

    virtualisation.oci-containers.containers.hermes-agent = {
      image = cfg.image;
      autoStart = true;
      # Mirrors upstream's docker-compose.yml, which uses host networking
      # for the gateway (needed for some messaging-platform webhooks).
      extraOptions = [ "--network=host" ];
      volumes = [ "${dataDir}:/opt/data" ];
      environment = {
        HERMES_UID = toString cfg.uid;
        HERMES_GID = toString cfg.gid;
      };
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      cmd = [ "gateway" "run" ];
    };

    virtualisation.oci-containers.containers.hermes-dashboard = lib.mkIf cfg.dashboard.enable {
      image = cfg.image;
      autoStart = true;
      dependsOn = [ "hermes-agent" ];
      extraOptions = [ "--network=host" ];
      volumes = [ "${dataDir}:/opt/data" ];
      environment = {
        HERMES_UID = toString cfg.uid;
        HERMES_GID = toString cfg.gid;
      };
      # Localhost-only by design — it stores API keys. For remote access,
      # tunnel via `ssh -L 9119:localhost:9119 tardis` rather than exposing
      # this on the LAN. See upstream docker-compose.yml's security notes.
      cmd = [ "dashboard" "--host" "127.0.0.1" "--no-open" ];
    };

    # oci-containers names the generated unit "podman-<container name>".
    # We hook its preStart to keep config.yaml's `model` block Nix-managed,
    # the same way the native module used to own it — everything else in
    # the file (skills, personality, platform tokens) is left alone.
    systemd.services."podman-hermes-agent".preStart = ''
      mkdir -p ${dataDir}
      cfgFile="${dataDir}/config.yaml"
      [ -f "$cfgFile" ] || echo "{}" > "$cfgFile"
      ${pkgs.yq-go}/bin/yq -i '
        .model.provider = "custom" |
        .model.default = "${cfg.model}" |
        .model.base_url = "${cfg.baseUrl}" |
        .model.api_key = "${apiKeyPlaceholder}"
      ' "$cfgFile"
      chown -R ${toString cfg.uid}:${toString cfg.gid} ${dataDir}
    '';

    # Restart the gateway automatically whenever the secret's content
    # changes (e.g. rotating the NanoGPT key), instead of requiring a
    # manual `systemctl restart podman-hermes-agent`.
    sops.secrets."hermes-env" = {
      restartUnits = [ "podman-hermes-agent.service" ];
    };
  };
}
