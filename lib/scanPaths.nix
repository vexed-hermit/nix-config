{ lib }: dir:
let
  entries = builtins.readDir dir;
in
builtins.attrValues (builtins.mapAttrs
  (name: type:
    if type == "directory" then dir + "/${name}"
    else dir + "/${name}"
  )
  (lib.filterAttrs
    (name: type:
      (type == "directory") ||
      (lib.hasSuffix ".nix" name && name != "default.nix"))
    entries))
