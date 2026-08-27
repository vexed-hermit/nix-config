{ config, ... }:
{
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
    wifi.macAddress = "stable";

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";   # "true" would break most captive portals
      dnsovertls = "opportunistic"; # encrypts when possible, falls back silently otherwise
      fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
    };

    networking.networkmanager.settings."connectivity" = {
      uri = "http://cp.cloudflare.com/";
      interval = 300;
    };

    ensureProfiles = {
      environmentFiles = [ config.sops.templates."wifi.env".path ];
      profiles = {
        home-wifi = {
          connection = {
            id = "home-wifi";
            type = "wifi";
            autoconnect = true;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "RAKESH KUMAR THAKUR _5g";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";   # use "sae" instead if the network is WPA3-only
            psk = "$WIFI_PASSWORD";
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };
  };
  # ...
}
