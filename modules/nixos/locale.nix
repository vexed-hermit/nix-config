{ ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  # Keep the system language in English, but use day-month-year date
  # formatting (e.g. 27/08/2026) instead of the US month-day-year style.
  # en_GB.UTF-8 gives DD/MM/YYYY while staying fully English.
  i18n.extraLocaleSettings = {
    LC_TIME = "en_GB.UTF-8";
  };

  # en_US.UTF-8 needs to be generated for the default locale to take effect.
  # en_GB.UTF-8 is generated for LC_TIME, and de_DE.UTF-8 is kept available
  # too, in case any app or user wants to fall back to it.
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
  ];
}
