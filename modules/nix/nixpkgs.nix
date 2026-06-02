{
  inputs,
  ...
}:
{
  flake.overlays.nixpkgsUnfree = final: _prev: {
    unfree = import inputs.nixpkgs {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
