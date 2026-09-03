{ pkgs, config, ... }:

{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${config.hostSettings.primaryUser}/nix-config";
  };

  programs.steam = {
    enable = true;

    # Integrates Protontricks directly with Steam's environment
    protontricks.enable = true;

    # Declaratively installs Proton-GE and exposes it to Steam
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    # Optional: Open firewall ports for Steam features
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.neovim.enable = true;
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
