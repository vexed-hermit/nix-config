{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../secrets/nixos.yaml;

  # Derive the age decryption key from the host's existing SSH host key,
  # so no separate key needs to be generated or provisioned on first boot.
  # Get the age pubkey for .sops.yaml with:
  #   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."wifi-password" = { };

  # neededForUsers = true makes sops-nix decrypt this before the
  # `users` activation step, since it's referenced via hashedPasswordFile.
  sops.secrets."user-doctor-password-hash" = {
    neededForUsers = true;
  };

  sops.secrets."some-api-token" = {
    owner = "doctor";
    mode = "0400";
  };
}
