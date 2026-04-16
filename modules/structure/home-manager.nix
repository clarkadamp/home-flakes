{
  self,
  lib,
  ...
}:
{
  flake.homeModules = {
    base =
      hmArgs@{ pkgs, ... }:
      let
        username = hmArgs.config.userProfile.username;
      in
      {
        imports = [
          {
            home.username = username;
            home.homeDirectory = lib.mkDefault "/${
              if pkgs.stdenv.isDarwin then "Users" else "home"
            }/${username}";
            programs.home-manager.enable = true;
            systemd.user.startServices = "sd-switch";
          }
        ];
      };
    gui = {
      imports = with self.homeModules; [
        base
      ];
    };
  };
}
