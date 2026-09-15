{ lib, config, ... }:

let
  cfg = config.custom.hermesAgent;
  # Dynamically resolve your home directory for bind mounts
  userHome = "/home/${config.hostSettings.primaryUser}";
in
{
  options.custom.hermesAgent = {
    enable = lib.mkEnableOption "Hermes Agent (NousResearch), run via the upstream NixOS module in Podman container mode";

    model = lib.mkOption {
      type = lib.types.str;
      default = "z-ai/glm-5.3-flash-uncensored";
      description = ''
        Model identifier passed to NanoGPT, e.g. "anthropic/claude-opus-4.6",
        "openai/gpt-5.2", or "google/gemini-3-flash-preview" — see
        https://nano-gpt.com/pricing for the full catalog.
      '';
    };

    messaging = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Pull in the messaging extra (Discord/Telegram/Slack adapters) via extraDependencyGroups.";
    };

    hostUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ config.hostSettings.primaryUser ];
      description = ''
        Interactive users who get a ~/.hermes symlink into the service state
        directory (sharing sessions/config/memories with the managed
        container) and are auto-added to the "hermes" group.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true; # puts `hermes` on PATH and routes it into the container automatically

      container = {
        enable = true;
        backend = "podman";
        hostUsers = cfg.hostUsers;
        # Fully-qualified so Podman doesn't need short-name resolution via
        # /etc/containers/registries.conf (unlike Docker, Podman on NixOS
        # has no default search registry unless one is configured).
        image = "docker.io/library/ubuntu:24.04";

        # Give the agent read/write access to your requested host directories.
        # They are mounted at the exact same absolute paths inside the container
        # so the agent's absolute path generation doesn't get confused.
        extraVolumes = [
          "${userHome}/nix-config:${userHome}/nix-config:rw"
          "${userHome}/Projects:${userHome}/Projects:rw"
          "${userHome}/Sillytavern:${userHome}/Sillytavern:rw"
          "${userHome}/Obsidian:${userHome}/Obsidian:rw"
          "${userHome}/Notes:${userHome}/Notes:rw"
        ];
      };

      settings = {
        # NanoGPT is OpenAI-compatible, so it's wired in as a named custom
        # provider rather than one of Hermes' built-in providers.
        providers.nanogpt = {
          api = "https://nano-gpt.com/api/v1";
          key_env = "NANO_GPT_API_KEY"; # matches secrets/tardis.yaml's hermes-env block
          transport = "chat_completions";
          default_model = cfg.model;
        };

        model = {
          provider = "nanogpt";
          default = cfg.model;
        };

        toolsets = [ "all" ];
      };

      extraDependencyGroups = lib.optionals cfg.messaging [ "messaging" ];

      environmentFiles = [ config.sops.secrets."hermes-env".path ];
    };

    # Container mode auto-enables Docker (via mkDefault) on the upstream
    # module; this host uses Podman instead (see modules/nixos/podman.nix),
    # whose docker-compat socket + CONTAINER_HOST already let the primary
    # user reach the root-owned container without sudo.
    virtualisation.docker.enable = lib.mkForce false;

    # Matches your existing secrets/tardis.yaml block:
    #   hermes-env: |
    #       NANO_GPT_API_KEY=sk-nano-...
    sops.secrets."hermes-env" = { format = "yaml"; };
  };
}
