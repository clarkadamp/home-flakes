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
  flake.modules.nixos.nixpkgs =
    { config, lib, ... }:
    {
      nixpkgs = lib.mkDefault {
        pkgs = withSystem config.hardware.facter.report.system (psArgs: psArgs.pkgs);
        hostPlatform = config.hardware.facter.report.system;
        overlays = [
          self.overlays.nixpkgsUnfree
        ];
      };
    };
  flake.modules.homeManager.nixpkgs =
    { lib, ... }:
    {
      nixpkgs = {
        overlays = [
          self.overlays.nixpkgsUnfree
        ];
      };
    };
}
