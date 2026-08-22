{ lib, config, ... }:

let
  cfg = config.custom.gitIdentity;
in
{
  options.custom.gitIdentity.enable = lib.mkEnableOption "personal git identity";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
        user.name = "vexed-hermit";
        user.email = "kumarvasu2006@gmail.com";
      };
    };
  };
}
