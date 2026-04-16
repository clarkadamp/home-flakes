{
  flake.homeModules.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs.unfree; [
        obsidian
      ];
    };
}
