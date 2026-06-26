{ self, ... }:
{
  flake.modules.nixos.systemDesktop = {
    imports = with self.modules.nixos; [
      audio
      autoPowerProfiles
      bluetooth
      systemCli
      keyboard
      chrome
      fonts
      keyboardRemaps
      networking
      hyprland
      noctaliaShell
      videoPlayer
      linuxDesktop
      terminalEmulator
    ];
  };

  flake.modules.darwin.systemDesktop = {
    imports = with self.modules.darwin; [
      bluetooth
      systemCli
      videoPlayer
      macNavigation
      terminalEmulator
    ];
  };

  flake.modules.homeManager.systemDesktop = {
    imports = with self.modules.homeManager; [
      audio
      systemCli
      chrome
      keyboard
      hyprland
      networking
      noctaliaShell
      videoPlayer
      terminalEmulator
    ];
  };
}
