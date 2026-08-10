{ lib, config, ... }:

let
  cfg = config.custom.flatpak;
in
{
  options.custom.flatpak.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.enable;
    description = "Flatpak support";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
