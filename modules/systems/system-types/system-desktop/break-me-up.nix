{
  flake.modules.nixos.linuxDesktop =
    { pkgs, ... }:
    {
      services.dbus.packages = with pkgs; [
        gcr
      ];

      security.pam.services.login.enableGnomeKeyring = true;
      programs.seahorse.enable = true;
    };

}
