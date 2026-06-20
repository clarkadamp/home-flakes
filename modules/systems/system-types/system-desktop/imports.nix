{ self, ... }:
{
  flake.modules.nixos.systemDesktop = {
    imports = with self.modules.nixos; [
      systemCli
      chrome
      fonts
      hyprland
      videoPlayer
      linuxDesktop
      terminalEmulator
    ];
  };

  flake.modules.darwin.systemDesktop = {
    imports = with self.modules.darwin; [
      systemCli
      videoPlayer
      macNavigation
      terminalEmulator
    ];
  };

  flake.modules.homeManager.systemDesktop = {
    imports = with self.modules.homeManager; [
      systemCli
      chrome
      terminalEmulator
    ];
  };
}
