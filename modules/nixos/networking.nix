{ ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
    wifi.macAddress = "stable";
    dns = "none";
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  # NetworkManager's own online-wait check is redundant with systemd-networkd-wait-online
  # and just slows down boot.
  systemd.services.NetworkManager-wait-online.enable = false;
}
