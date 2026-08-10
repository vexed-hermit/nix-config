{ config, pkgs, ... }:

{
  # neededForUsers = true makes sops-nix decrypt this before the
  # `users` activation step, since it's referenced via hashedPasswordFile.
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
