{ lib, config, ... }:

let
  cfg = config.custom.heliumBrowser;
  helium = import ../../lib/helium.nix;
in
{
  options.custom.heliumBrowser.enable = lib.mkEnableOption "Helium browser";

  config = lib.mkIf cfg.enable {
    programs.helium = {
      enable = true;
      flags = helium.flags;
    };
  };
}
