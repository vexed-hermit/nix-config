{ lib, config, ... }:

let
  cfg = config.custom.sillytavern;
in
{
  options.custom.sillytavern = {
    enable = lib.mkEnableOption "SillyTavern chat frontend, run as a podman container managed by systemd";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Host port SillyTavern is reachable on.";
    };

    imageTag = lib.mkOption {
      type = lib.types.str;
      default = "latest";
      description = ''
        Image tag to run: "latest" (stable) or "staging" (development branch).
      '';
    };

    exposeOnLan = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Bind to 0.0.0.0 instead of 127.0.0.1 and open the firewall port.
        SillyTavern has no built-in auth and warns against exposing it to
        the internet without a separate auth proxy; only enable this for
        trusted LANs.
      '';
    };

    enableServerPlugins = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SillyTavern server plugins (enableServerPlugins in config.yaml).";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "podman";

    virtualisation.oci-containers.containers.sillytavern = {
      image = "ghcr.io/sillytavern/sillytavern:${cfg.imageTag}";
      autoStart = true;
      ports = [
        "${if cfg.exposeOnLan then "0.0.0.0" else "127.0.0.1"}:${toString cfg.port}:8000"
      ];
      volumes = [
        "sillytavern-config:/home/node/app/config"
        "sillytavern-data:/home/node/app/data"
        "sillytavern-plugins:/home/node/app/plugins"
        "sillytavern-extensions:/home/node/app/public/scripts/extensions/third-party"
      ];
      environment = {
        NODE_ENV = "production";
        SILLYTAVERN_HEARTBEATINTERVAL = "30";
        SILLYTAVERN_ENABLESERVERPLUGINS = lib.boolToString cfg.enableServerPlugins;
        # Podman rewrites the source IP of ALL port-forwarded connections
        # (loopback or LAN alike) to its bridge gateway, so the default
        # whitelist ("::1", "127.0.0.1") blocks everything. ST's built-in
        # whitelistDockerHosts detection targets Docker's 172.17.0.0/16
        # bridge, not Podman's 10.88.0.0/16, so it doesn't help here.
        # NOTE: because every port-forwarded client looks identical to ST
        # (same gateway IP), this whitelist can no longer distinguish
        # localhost from LAN traffic -- real access control already comes
        # from `exposeOnLan` (bind address + firewall), not from this list.
        SILLYTAVERN_WHITELIST = builtins.toJSON [ "::1" "127.0.0.1" "10.88.0.1" ];
      };
      extraOptions = [ "--pull=newer" ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.exposeOnLan [ cfg.port ];
  };
}
