{ lib, config, ... }:

let
  cfg = config.custom.hermesAgent;
in
{
  options.custom.hermesAgent = {
    enable = lib.mkEnableOption "Hermes Agent (NousResearch), run natively as a hardened systemd service";

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

    addToSystemPackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''...'';
    };
  };

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      settings.model = {
        provider = "custom";
        default = cfg.model;
        base_url = cfg.baseUrl;
        # provider = "custom" only auto-detects OPENAI_API_KEY by default;
        # since the secret is named NANO_GPT_API_KEY, point at it explicitly.
        # ${...} here is resolved by Hermes from $HERMES_HOME/.env at runtime,
        # not by Nix — hence the escaped \${...}.
        api_key = "\${NANO_GPT_API_KEY}";
      };
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = cfg.addToSystemPackages;
    };

    # Restart the service automatically whenever the secret's content changes
    # (e.g. rotating the NanoGPT key), instead of requiring a manual
    # `systemctl restart hermes-agent`.
    sops.secrets."hermes-env" = {
      restartUnits = [ "hermes-agent.service" ];
    };
  };
}
