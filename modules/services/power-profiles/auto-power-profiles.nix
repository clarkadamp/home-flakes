{
  flake.modules.nixos.autoPowerProfiles =
    { pkgs, lib, ... }:
    let
      powerProfileAuto = lib.getExe (
        pkgs.writeShellApplication {
          name = "power-profile-auto";
          runtimeInputs = with pkgs; [
            power-profiles-daemon
          ];
          text = builtins.readFile ./power-profile-auto;
        }
      );
    in
    {
      services = {
        power-profiles-daemon.enable = true;
        udev.packages = [
          (pkgs.writeTextFile {
            name = "power-profiles-udev-rules";
            destination = "/etc/udev/rules.d/99-power-profile.rules";
            text = ''
              SUBSYSTEM=="power_supply", KERNEL=="AC*", ACTION=="change", RUN+="${powerProfileAuto}"
            '';
          })
        ];
      };
      systemd.services.power-profile-auto = {
        unitConfig = {
          Description = "Set power profile based on AC state at boot";
          After = [ "multi-user.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStart = powerProfileAuto;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

}
# vim: ts=2 sts=2 sw=2 et
