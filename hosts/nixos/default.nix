{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  time.timeZone = "Asia/Kathmandu";

  users.users."doctor" = {
    isNormalUser = true;
    description = "Doctor";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Leave this as the release you first installed with; see NixOS docs on stateVersion.
  system.stateVersion = "26.05";
}
