{ ... }:

{
  services.syncthing = {
    enable = true;
    user = "doctor";
    dataDir = "/home/doctor";
    configDir = "/home/doctor/.config/syncthing";
    openDefaultPorts = true; # 22000/tcp, 21027/udp

    settings = {
      devices = {
        phone = {
          id = "6XTPSIU-NQALQUC-VVSALKR-N7CJ647-VHMAG5E-CGTI3KS-PZ45737-4HYSHQR";
        };
      };

      folders = {
        "Documents" = {
          id = "documents";
          path = "/home/doctor/Documents";
          devices = [ "phone" ]; # e.g. [ "laptop" ]
        };
      };
    };
  };
}
