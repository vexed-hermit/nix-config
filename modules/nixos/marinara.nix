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
      autoStart = false;
      ports = [
        "${if cfg.exposeOnLan then "0.0.0.0" else "127.0.0.1"}:${toString cfg.port}:7860"
      ];
      # Named volume; /var/lib/containers is already in the impermanence
      # persistence list, so this survives reboots.
      volumes = [ "marinara-data:/app/data" ];
      # Always wired in, not just when exposeOnLan: podman NAT means the
      # container sees the bridge gateway address, not literally 127.0.0.1,
      # as the source of "local" requests -- so Marinara's loopback check
      # fails even for plain http://127.0.0.1:7860 access from this host.
      # ADMIN_SECRET is the documented fallback for that case. Paste the
      # same value into Settings -> Advanced -> Admin Access in the app.
      environmentFiles = [ config.sops.templates."marinara.env".path ];
      extraOptions = [ "--pull=newer" ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.exposeOnLan [ cfg.port ];

    sops.secrets = {
      "marinara-admin-secret" = { };
    } // lib.optionalAttrs cfg.exposeOnLan {
      "marinara-basic-auth-pass" = { };
    };

    sops.templates."marinara.env".content = ''
      ADMIN_SECRET=${config.sops.placeholder."marinara-admin-secret"}
    '' + lib.optionalString cfg.exposeOnLan ''
      BASIC_AUTH_USER=${cfg.basicAuthUser}
      BASIC_AUTH_PASS=${config.sops.placeholder."marinara-basic-auth-pass"}
    '';
  };
}
