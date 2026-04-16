{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake.overlays.nixpkgsUnfree = final: _prev: {
    unfree = import inputs.nixpkgs {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
  flake.modules = {
    homeManager.nixpkgs.nixpkgs.overlays = [
      self.overlays.nixpkgsUnfree
    ];
    nixos.base = nixosArgs: {
      nixpkgs = {
        pkgs = withSystem nixosArgs.config.hardware.facter.report.system (psArgs: psArgs.pkgs);
        hostPlatform = nixosArgs.config.hardware.facter.report.system;
        overlays = [
          self.overlays.nixpkgsUnfree
        ];
      };
    };
  };
}
