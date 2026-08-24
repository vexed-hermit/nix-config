{ ... }:
{
  # Intel thermal management — prevents unnecessary throttling under load
  services.thermald.enable = true;

  # Ensures microcode updates and other redistributable firmware are pulled in
  # (hardware-configuration.nix already references this via mkDefault for
  # intel.updateMicrocode, so this turns that on too)
  hardware.enableRedistributableFirmware = true;

  # Weekly TRIM instead of continuous discard — safer default for btrfs/NVMe
  services.fstrim.enable = true;
}
