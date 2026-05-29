{ self, ... }:
{
  flake.modules.nixos.fonts = {
    home-manager.sharedModules = with self.modules.homeManager; [
      fonts
    ];
  };
  flake.modules.darwin.fonts = {
    imports = with self.modules.dawrin; [ homebrew ];
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
        roboto-mono
        font-awesome
        nerd-fonts.arimo
      ];
    };
}
