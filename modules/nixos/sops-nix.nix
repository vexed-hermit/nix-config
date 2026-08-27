{ inputs, hostname, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../secrets/${hostname}.yaml;

  sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."wifi-password" = { };

  sops.templates."wifi.env".content = ''
    WIFI_PASSWORD=${config.sops.placeholder."wifi-password"}
  '';
}
