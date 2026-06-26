{ self, ... }:
{
  flake.modules.darwin.macApps = {
    imports = with self.modules.darwin; [ homebrew ];
    homebrew = {
      casks = [
        "bluesnooze"
      ];
    };
  };
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bluez
      ];
      services.blueman.enable = true;
      hardware.bluetooth.enable = true;
    };
}
# vim: ts=2 sts=2 sw=2 et
