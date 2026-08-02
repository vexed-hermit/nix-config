{ ... }:

let
  helium = import ../../lib/helium.nix;
in

{
  # Chromium-based browsers only reliably read managed policies from
  # /etc/{chromium,helium}/policies/managed/, not from a per-user path,
  # so this has to live at the system level rather than in home-manager.
  environment.etc."chromium/policies/managed/helium-nixos.json".text =
    builtins.toJSON helium.policies;

  environment.etc."helium/policies/managed/helium-nixos.json".text = builtins.toJSON helium.policies;
}
