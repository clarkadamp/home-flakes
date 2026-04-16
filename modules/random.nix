{
  flake.homeModules.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        flamegraph
        graphviz
        gron
        stow
        wget
        yq
      ];
    };
}
