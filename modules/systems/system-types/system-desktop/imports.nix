{ self, ... }:
{
  flake.modules.nixos.systemDesktop = {
    imports = with self.modules.nixos; [
      androidDevices
      audio
      autoPowerProfiles
      bluetooth
      discord
      systemCli
      keyboard
      chrome
      fonts
      keyboardRemaps
      gtk
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
      fonts
      systemCli
      videoPlayer
      macNavigation
      terminalEmulator
    ];
  };

  flake.modules.homeManager.systemDesktop = {
    imports = with self.modules.homeManager; [
      audio
      discord
      systemCli
      chrome
      keyboard
      hyprland
      gtk
      networking
      noctaliaShell
      videoPlayer
      terminalEmulator
    ];
  };
}
