{ config, pkgs, ... }:

{
  sops.secrets."user-doctor-password-hash" = {
    neededForUsers = true;
  };

  sops.secrets."some-api-token" = {
    owner = "doctor";
    mode = "0400";
  };

  users.users."doctor" = {
    isNormalUser = true;
    description = "Doctor";
    hashedPasswordFile = config.sops.secrets."user-doctor-password-hash".path;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
