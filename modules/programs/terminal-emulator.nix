{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      terminalEmulator
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
        # ghostty-bin
      ];
    };

  flake.modules.homeManager.terminalEmulator =
    { pkgs, ... }:
    let
      solarizedDark = "Builtin Solarized Dark";
    in
    {
      home.packages = with pkgs; [
      ];
      programs.ghostty = {
        enable = true;
        package = with pkgs; if pkgs.stdenv.isDarwin then ghostty-bin else ghostty;
        enableZshIntegration = true;
        installVimSyntax = true;
        settings = {
          theme = solarizedDark;
          "font-size" = 11;
          "font-family" = "JetBrainsMono Nerd Font";

        };
        themes = {
          "${solarizedDark}" = {
            palette = [
              "0=#073642"
              "1=#dc322f"
              "2=#859900"
              "3=#b58900"
              "4=#268bd2"
              "5=#d33682"
              "6=#2aa198"
              "7=#eee8d5"
              "8=#335e69"
              "9=#cb4b16"
              "10=#586e75"
              "11=#657b83"
              "12=#839496"
              "13=#6c71c4"
              "14=#93a1a1"
              "15=#fdf6e3"
            ];
            background = "#002b36";
            foreground = "#839496";
            cursor-color = "#839496";
            cursor-text = "#073642";
            selection-background = "#073642";
            selection-foreground = "#93a1a1";
          };
        };
      };
    };
}
