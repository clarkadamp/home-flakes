{ inputs, self, ... }:
{
  config.flake.lib.pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [
        self.overlays.nixpkgsUnfree
      ];
    };
}
