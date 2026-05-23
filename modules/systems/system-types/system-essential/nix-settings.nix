let
  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
    };
  };
in
{
  flake.modules.nixos.systemEssential = {
    inherit nix;
  };

  flake.modules.darwin.systemEssential = {
    inherit nix;
  };

  flake.modules.homeManager.systemBasic =
    { lib, pkgs, ... }:
    {
      nix = nix // {
        package = lib.mkDefault pkgs.nix;
      };
    };

}
