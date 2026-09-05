{ lib, config, ... }:

let
  cfg = config.custom.marinara;
in
{
  options.custom.marinara = {
    enable = lib.mkEnableOption "Marinara Engine, run as a podman container managed by systemd";

    port = lib.mkOption {
      type = lib.types.port;
      default = 7860;
      description = "Host port Marinara is reachable on.";
    };

    imageTag = lib.mkOption {
      type = lib.types.str;
      default = "latest";
      description = ''
        Image tag to run: "latest" (stable), "lite" (smaller, no local
        model/embeddings/Whisper), a pinned "X.Y.Z", or "X.Y.Z-lite".
      '';
    };

    exposeOnLan = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Bind to 0.0.0.0 instead of 127.0.0.1 and open the firewall port.
        Do not turn this on until the marinara-basic-auth-pass and
        marinara-admin-secret sops secrets exist (see below) -- the
        upstream docs are explicit that this must never be exposed
        without Basic Auth in front of it.
      '';
    };

    basicAuthUser = lib.mkOption {
      type = lib.types.str;
      default = "doctor";
      description = "Username for Basic Auth when exposeOnLan is true.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "podman";

    virtualisation.oci-containers.containers.marinara = {
      image = "ghcr.io/pasta-devs/marinara-engine:${cfg.imageTag}";
      autoStart = true;
      ports = [
        "${if cfg.exposeOnLan then "0.0.0.0" else "127.0.0.1"}:${toString cfg.port}:7860"
      ];
      # Named volume; /var/lib/containers is already in the impermanence
      # persistence list, so ix into modulthis survives reboots.
      volumes = [ "marinara-data:/app/data" ];
      environmentFiles = lib.mkIf cfg.exposeOnLan [
        config.sops.templates."marinara.env".path
      ];
      extraOptions = [ "--pull=newer" ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.exposeOnLan [ cfg.port ];

    sops.secrets = lib.mkIf cfg.exposeOnLan {
      "marinara-basic-auth-pass" = { };
      "marinara-admin-secret" = { };
    };

    sops.templates."marinara.env" = lib.mkIf cfg.exposeOnLan {
      content = ''
        BASIC_AUTH_USER=${cfg.basicAuthUser}
        BASIC_AUTH_PASS=${config.sops.placeholder."marinara-basic-auth-pass"}
        ADMIN_SECRET=${config.sops.placeholder."marinara-admin-secret"}
      '';
    };
  };
}
