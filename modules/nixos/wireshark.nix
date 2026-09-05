{ lib, config, ... }:

let
  cfg = config.custom.wireshark;
in
{
  options.custom.wireshark.enable = lib.mkEnableOption "Wireshark network protocol analyzer";

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
    };

    users.users.${config.hostSettings.primaryUser}.extraGroups = [ "wireshark" ];
  };
}
