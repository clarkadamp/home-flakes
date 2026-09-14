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
      system.defaults.CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Disable 'Cmd + Space' for Spotlight Search
            "64" = {
              enabled = false;
            };
          };
        };
      };
    };

}
# vim: ts=2 sts=2 sw=2 et
