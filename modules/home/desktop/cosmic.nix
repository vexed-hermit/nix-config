{ lib, config, ... }:
let
  cfg = config.custom.desktop.cosmic;
in
{
  options.custom.desktop.cosmic.enable = lib.mkEnableOption "COSMIC desktop session config";

  config = lib.mkIf cfg.enable {
    # home-manager doesn't have mature COSMIC options yet — fill in as they land
  };
}
