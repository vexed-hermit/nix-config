{ ... }:
{
  # Root ("/") is tmpfs and is wiped every boot (see hardware-configuration.nix).
  # Anything listed here is bind-mounted from the real, persistent
  # /persist subvolume back into its normal path on the ephemeral root.
  #
  # Rule of thumb: if it's not listed here, it does not survive a reboot.
  # When something breaks after a reboot ("why did X reset?"), it's almost
  # always because X's state lives somewhere not covered below — add the
  # path and rebuild.
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/nixos" # uid/gid allocation state — losing this can reshuffle user/group ids
      "/var/lib/systemd/coredump"
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager" # NM's own state, separate from the connection profiles below
      "/etc/NetworkManager/system-connections" # saved wifi/ethernet connections (wifi-password itself still comes from sops)
      "/var/lib/libvirt" # VM definitions/disks metadata if you keep VMs on this host
      "/var/lib/flatpak"
      "/var/lib/syncthing" # harmless if unused since syncthing's real data/config dir is under /home
    ];

    files = [
      "/etc/machine-id" # stable machine identity; dbus/systemd-journal and some apps care about this
      "/etc/ssh/ssh_host_ed25519_key" # sops-nix decrypts secrets/tardis.yaml using this — losing it locks you out of your secrets
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
