{ lib, config, ... }:

let
  cfg = config.custom.powerManagement;
in
{
  options.custom.powerManagement.enable = lib.mkEnableOption "TLP-based laptop power/battery management";

  config = lib.mkIf cfg.enable {

    # TLP takes over AC/battery power tuning. It conflicts with
    # power-profiles-daemon (both try to manage the same knobs), and Plasma 6
    # enables PPD by default — so we turn it off here.
    #
    # Trade-off: this removes the manual Balanced/Performance/Battery-Saver
    # slider from the Plasma battery widget, and the "powerProfile" shortcut
    # (Meta+B) in plasma.nix will no longer do anything, since both are backed
    # by power-profiles-daemon. In exchange, TLP automatically re-tunes
    # everything the instant you plug/unplug — no manual switching needed.
    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;
      settings = {
        # --- CPU ---
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Cap turbo boost on battery only; full turbo available on AC.
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 60;

        # --- Platform / Intel-specific ---
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # --- PCIe Active State Power Management ---
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # --- Disk / NVMe ---
        DISK_IDLE_SECS_ON_AC = 0;
        DISK_IDLE_SECS_ON_BAT = 2;
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";
        NMI_WATCHDOG = 0;

        # --- USB autosuspend ---
        # TLP whitelists HID/input devices automatically, so keyboards/mice
        # don't get suspended even with this on.
        USB_AUTOSUSPEND = 1;

        # --- Radios ---
        # Deliberately left untouched: WiFi power save is controlled in
        # networking.nix (currently off, kept off there for connection
        # stability). Not setting WIFI_PWR_ON_AC/BAT here avoids TLP fighting
        # with that setting.

        # --- Battery charge thresholds ---
        # Many ThinkPads/Dells/Frameworks support stopping charge at ~80% to
        # slow long-term battery wear. Uncomment and adjust if your hardware
        # supports it (check with: tlp-stat -b). Left off by default since
        # not all hardware does.
        # START_CHARGE_THRESH_BAT0 = 75;
        # STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
