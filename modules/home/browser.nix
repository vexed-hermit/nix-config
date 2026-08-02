{ ... }:

let
  helium = import ../../lib/helium.nix;
in

{
  programs.helium = {
    enable = true;
    flags = helium.flags;
  };
}
