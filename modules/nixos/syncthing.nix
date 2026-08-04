{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "doctor";
    dataDir = "/home/doctor";
    configDir = "/home/doctor/.config/syncthing";
    openDefaultPorts = true; # 22000/tcp, 21027/udp

    settings = {
      devices = {
        # laptop = { id = "DEVICE-ID-HERE"; };
      };
      folders = {
        "Documents" = {
          path = "/home/doctor/Documents";
          devices = [ ]; # e.g. [ "laptop" ]
        };
      };
    };
  };
}
