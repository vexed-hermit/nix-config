{ lib, config, ... }:
let
  cfg = config.custom.browserPolicies;
  helium = import ../../lib/helium.nix;
in
{
  options.custom.browserPolicies.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.enable;
    description = "System-level Chromium/Helium managed policies";
  };

  config = lib.mkIf cfg.enable {
    environment.etc."chromium/policies/managed/helium-nixos.json".text =
      builtins.toJSON helium.policies;
    environment.etc."helium/policies/managed/helium-nixos.json".text =
      builtins.toJSON helium.policies;
  };
}
