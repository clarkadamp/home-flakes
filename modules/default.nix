{ config, ... }:
{
  flake.homeModules.base =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        htop
        fortune
      ];

    };
}
