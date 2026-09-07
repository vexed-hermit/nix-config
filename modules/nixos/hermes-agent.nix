{ lib, config, ... }:

let
  cfg = config.custom.hermesAgent;
in
{
  options.custom.hermesAgent = {
    enable = lib.mkEnableOption "Hermes Agent (NousResearch), run natively as a hardened systemd service";

    model = lib.mkOption {
      type = lib.types.str;
      default = "anthropic/claude-sonnet-4";
      description = ''...'';
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
      settings.model.default = cfg.model;
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = cfg.addToSystemPackages;
    };

    sops.secrets."hermes-env" = { };
  };
}
