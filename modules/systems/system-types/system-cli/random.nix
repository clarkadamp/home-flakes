{
  flake.modules.homeManager.systemCli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # TODO: break me up
        flamegraph
        graphviz
        gron
        stow
        wget
        yq
        gcc
        python3
        ruby
        go
        rustup
        nixfmt-tree
        htop
        fortune
        systemctl-tui
      ];
    };
}
