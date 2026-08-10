{ lib, config, ... }:

let
  cfg = config.custom.printing;
in
{
  options.custom.printing.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.enable;
    description = "CUPS printing support";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
