{ config, ... }:

{
  sops.secrets."user-guest-password-hash" = {
    neededForUsers = true;
  };

  users.users."guest" = {
    isNormalUser = true;
    description = "Guest";
    hashedPasswordFile = config.sops.secrets."user-guest-password-hash".path;
    extraGroups = [
      "networkmanager"
    ];
  };
}
