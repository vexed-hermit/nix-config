{
  # Command-line flags — baked into the wrapper by the home-manager
  # module (programs.helium.flags in home.nix).
  flags = [
    "--ozone-platform-hint=auto"
    "--enable-features=TouchpadOverscrollHistoryNavigation"
    "--start-maximized"
    "--use-angle=vulkan"
  ];

  # Chrome Enterprise policies — written to /etc by configuration.nix.
  # Must live at the system level: Chromium-based browsers only reliably
  # read managed policies from /etc/{chromium,helium}/policies/managed/,
  # not from the per-user home-manager path.
  policies = {
    "PasswordManagerEnabled" = false;
    "SpellcheckEnabled" = true;
    "SpellcheckLanguage" = [ "en-US" ];
    "DefaultSearchProviderEnabled" = true;
    "DefaultSearchProviderSearchURL" = "https://www.google.com/search?q={searchTerms}";
    "ExtensionInstallForcelist" = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "hoombieeljmmljlkjmnheibnpciblicm" # Language Reactor
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
    ];
  };
}
