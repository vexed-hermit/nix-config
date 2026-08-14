{ ... }:

{
  i18n.defaultLocale = "de_DE.UTF-8";

  # de_DE.UTF-8 needs to be generated for the default locale to take effect.
  # en_US.UTF-8 is kept available/generated too, in case any app or user
  # wants to fall back to it.
  i18n.supportedLocales = [
    "de_DE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
}
