{ ... }:

{
  services.flatpak = {
    packages = [
      "com.stremio.Stremio"
    ];
    update.onActivation = true;
  };
}
