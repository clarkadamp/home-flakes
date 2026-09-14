{ self, ... }:
{
  flake.modules.nixos.fonts = {
    home-manager.sharedModules = with self.modules.homeManager; [
      fonts
    ];
  };
  flake.modules.darwin.fonts = {
    imports = with self.modules.darwin; [ homebrew ];
    home-manager.sharedModules = with self.modules.homeManager; [
      fonts
    ];
    homebrew = {
      casks = [
        "font-hack-nerd-font"
      ];
    };
  };
  flake.modules.homeManager.fonts =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
      ];
    };
}
