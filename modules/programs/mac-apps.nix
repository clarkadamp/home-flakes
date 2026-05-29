{ self, ... }:
{

  flake.modules.darwin.macApps = {
    imports = with self.modules.darwin; [ homebrew ];
    homebrew = {
      casks = [
        "bluesnooze"
        "clocker"
        "openmtp"
      ];
    };
  };
}
# vim: ts=2 sts=2 sw=2 et
