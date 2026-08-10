{ lib, config, ... }:

let
  cfg = config.custom.bluetooth;
in
{
  options.custom.bluetooth.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.custom.desktop.enable;
    description = "Bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
