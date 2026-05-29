{ self, ... }:
{
  flake.modules.nixos.systemDesktop = {
    imports = with self.modules.nixos; [
      systemCli
      fonts
      hyprland
      videoPlayer
      linuxDesktop
    ];
  };

  flake.modules.darwin.systemDesktop = {
    imports = with self.modules.darwin; [
      systemCli
      videoPlayer
      macNavigation
    ];
  };

  flake.modules.homeManager.systemDesktop = {
    imports = with self.modules.homeManager; [
      systemCli
    ];
  };
}
