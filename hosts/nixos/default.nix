{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./stylix.nix
  ];

  time.timeZone = "Asia/Kathmandu";

  # Leave this as the release you first installed with; see NixOS docs on stateVersion.
  system.stateVersion = "26.05";
}
