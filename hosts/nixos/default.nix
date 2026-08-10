{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  time.timeZone = "Asia/Kathmandu";

  # Leave this as the release you first installed with; see NixOS docs on stateVersion.
  system.stateVersion = "26.05";
}
