{ lib, config, pkgs, ... }:
let
  cfg = config.custom.obsidian;
in
{
  options.custom.obsidian.enable = lib.mkEnableOption "Obsidian setup";
  config = lib.mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
      package = pkgs.obsidian;
      cli.enable = true;
      vaults."Vault01" = {
        enable = true;
        # target defaults to the attribute name, so this line is optional —
        # shown here for clarity.
        target = "Obsidian/Vault01";
      };
    };
  };
}
