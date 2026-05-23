{ self, lib, ... }:
let
  username = "cladam";
  fullName = "TestUser";
  email = "test@test.com";
  linuxHome = "/home/${username}";
  darwinHome = "/Users/${username}";
  home-manager = {
    users.${username} = {
      imports = with self.modules.homeManager; [
        validateBuild
      ];
    };
  };
in
{
  flake.modules.nixos.validateBuild = lib.mkMerge [
    {

      hardware.facter.reportPath = ./test-system.json;
      boot.loader.grub.device = "/dev/sda";
      fileSystems = {
        "/" = {
          device = "/dev/sda1";
          fsType = "ext4";
        };
      };
    }
    {
      inherit home-manager;
      users.users.${username} = {
        description = fullName;
        home = linuxHome;
        isNormalUser = true;
      };
    }
    {
      imports = with self.modules.nixos; [
        systemDesktop
      ];
    }
  ];
  flake.nixosConfigurations = self.factory.mkNixos "x86_64-linux" "validateBuild";

  flake.modules.homeManager.validateBuild =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      home.username = username;
      home.homeDirectory = lib.mkDefault (if pkgs.stdenv.isDarwin then darwinHome else linuxHome);
      programs = {
        git.settings.user = {
          inherit email;
          name = username;
        };
      };
      dotfilesRoot = rec {
        "system-flakes" = "${config.home.homeDirectory}/system-flakes";
        "home-flakes" = "${system-flakes}/inputs/home-flakes";
      };
    };
}
