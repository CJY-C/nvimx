{ lib, ... }:

{
  imports = lib.mapAttrsToList (name: _: ./. + "/${name}") (
    lib.filterAttrs (name: type: name != "default.nix" && (type == "regular" || type == "directory")) (builtins.readDir ./.)
  );
}
