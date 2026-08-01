{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  helium = inputs.helium-browser.packages.${system}.default;
in

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  #networking.hostName = "nixos";

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
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  time.timeZone = "Asia/Kathmandu";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  users.users."doctor" = {
    isNormalUser = true;
    description = "Doctor";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/doctor/Projects/nix-config";
  };

  programs.kdeconnect.enable = true;

  programs.neovim.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    helium
    vim
    zed-editor
    ghostty
  ];

  system.stateVersion = "26.05";
}
