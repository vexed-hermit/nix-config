{ ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  # en_US.UTF-8 formats dates as MM/DD/YYYY; override just LC_TIME so
  # dates render unambiguously while everything else (language,
  # currency, etc.) stays en_US.
  #
  # en_DK.UTF-8 is used rather than en_GB.UTF-8: it keeps English day/
  # month names but formats dates as YYYY-MM-DD (ISO 8601) instead of
  # DD/MM/YYYY. ISO order sorts correctly as plain text (e.g. in
  # filenames, logs, `ls -l`) and can't be confused with MM/DD/YYYY at
  # a glance the way DD/MM/YYYY still can.
  i18n.extraLocaleSettings = {
    LC_TIME = "en_DK.UTF-8";
  };

  # en_DK.UTF-8 needs to be generated for the override above to take effect.
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];
}
