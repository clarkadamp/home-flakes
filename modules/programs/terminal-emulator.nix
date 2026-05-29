{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
    ];
  };
in
{
  flake.modules.nixos.terminalEmulator =
    { pkgs, ... }:
    {
      inherit home-manager;
    };

  flake.modules.darwin.terminalEmulator =
    { pkgs, ... }:
    {
      inherit home-manager;
      environment.systemPackages = with pkgs; [
      ];
    };

  flake.modules.homeManager.terminalEmulator =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
      ];
      programs.ghostty = {
        enable = true;
        package = null;
        settings = {
          "theme" = "Builtin Solarized Dark";
        };
      };
    };
}
