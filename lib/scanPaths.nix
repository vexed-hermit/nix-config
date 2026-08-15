{ lib }: dir:
let
  entries = builtins.readDir dir;
  reserved = [ "default.nix" "meta.nix" "home-overrides" ];
in
builtins.attrValues (builtins.mapAttrs
  (name: type: dir + "/${name}")
  (lib.filterAttrs
    (name: type:
      !(builtins.elem name reserved) &&
      ((type == "directory") || lib.hasSuffix ".nix" name))
    entries))
