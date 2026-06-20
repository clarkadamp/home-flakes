{
  self,
  inputs,
  lib,
  ...
}:
{

  flake.modules.homeManager.noctaliaShell =
    { pkgs, config, ... }:
    let
      noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      noctaliaExe = lib.getExe noctalia;
    in
    {
      imports = [
        # inputs.noctalia.homeModules.default
      ];
      home.packages = [
        noctalia
      ];
      wayland.windowManager.hyprland =
        let
          inherit (self.factory.hyprland)
            bind'
            mainMod
            on
            ;
        in
        {
          settings = {
            on = lib.lists.flatten [
              (on "hyprland.start" noctaliaExe)
            ];
            bind = [
              (bind' "${mainMod} + Return" "exec_cmd" "${noctaliaExe} ipc call launcher toggle")
            ];
          };
        };
      xdg.configFile = self.factory.symlinkDotfiles {
        hmConfig = config;
        path = ../../../dotfiles/dotConfig/noctalia;
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
