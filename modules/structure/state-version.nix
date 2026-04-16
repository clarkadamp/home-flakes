{ lib, ... }:
{
  flake.modules = {
    nixos.base.system.stateVersion = lib.mkDefault "25.11";
    homeManager.base.home.stateVersion = lib.mkDefault "25.11";
  };
}
