{
  flake.modules.darwin.macSettings = {
    system = {
      defaults = {
        dock = {
          autohide = true;
        };
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          NSWindowShouldDragOnGesture = true;
        };
      };
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
