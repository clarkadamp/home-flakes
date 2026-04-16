{
  flake.homeModules.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
        python3
        ruby
        go
        rustup
        nixfmt-tree
      ];
    };
}
