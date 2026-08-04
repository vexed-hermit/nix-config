{ config, pkgs, ... }:

{
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
