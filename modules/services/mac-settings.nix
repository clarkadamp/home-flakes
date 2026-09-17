{ self, ... }: {
  flake.modules.darwin.macSettings = {
    imports = with self.modules.darwin; [
      pmset
    ];
    system = {
      defaults = {
        ".GlobalPreferences"."com.apple.mouse.scaling" = 10.0;
        dock.autohide = true;
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          NSWindowShouldDragOnGesture = true;
        };
        # universalaccess.reduceMotion = true;
        hitoolbox.AppleFnUsageType = "Do Nothing";
        menuExtraClock = {
          ShowAMPM = false;
          Show24Hour = true;
          ShowDayOfWeek = true;
          ShowDate = 0;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          ShowStatusBar = true;
        };
      };
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
      pmset = {
        all = {
          displaysleep = 15;
          sleep = 0;
          powernap = 0;
          womp = 0;
          proximitywake = 0;
          lidwake = 1;
          acwake = 1;
        };
        battery = {
          displaysleep = 10;
          sleep = 15;
        };
      };
    };
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
# vim: ts=2 sts=2 sw=2 et
