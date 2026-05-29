{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.modules.flake.nixpkgs = {
    options.nixpkgs = {
      overlays = lib.mkOption {
        type = lib.types.listOf lib.types.unspecified;
        default = [ ];
      };
      factory = lib.mkOption {
        type = lib.types.functionTo lib.types.pkgs;
        readOnly = true;
        default =
          system:
          import inputs.nixpkgs {
            inherit system;
            inherit (config.nixpkgs) overlays;
          };
      };
    };

    config = {
      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = config.nixpkgs.factory system;
        };
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
