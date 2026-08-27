{ ... }:
{
  # Declarative partitioning/formatting/mounting for tardis's NVMe.
  # Mirrors the layout that used to be hand-written in hardware-configuration.nix:
  #   nvme0n1p1  1G     vfat   -> /boot
  #   nvme0n1p2  ~458G  btrfs  -> subvolumes: home, nix, persist
  #   nvme0n1p3  17G    swap
  # Root ("/") is NOT a disk-backed filesystem: it's tmpfs, wiped every boot.
  # That's declared under disko.devices.nodev below, and impermanence.nix
  # bind-mounts everything that needs to survive out of the "persist" subvolume.
  #
  # To (re)install with this:
  #   sudo nix run github:nix-community/disko -- --mode destroy,format,mount \
  #     --flake .#tardis
  # WARNING: this destroys all data on the target disk. Double-check the
  # device name below before running.

  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "fmask=0077" "dmask=0077" ];
            };
          };

          swap = {
            size = "17G";
            content = {
              type = "swap";
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # force, in case the partition was used before
              subvolumes = {
                # Names match the original "subvol=home" / "subvol=nix" /
                # "subvol=persist" mount options exactly, so nothing else
                # in the config needs to change.
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "mode=755" "size=2G" ];
    };
  };
}
