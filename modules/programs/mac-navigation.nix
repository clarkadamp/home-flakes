{

  flake.modules.darwin.macNavigation =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
      ];
      homebrew = {
        casks = [
          "raycast"
        ];
      };
    };

}
# vim: ts=2 sts=2 sw=2 et
