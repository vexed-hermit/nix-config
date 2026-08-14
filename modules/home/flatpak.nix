{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
}
