{
  flake.modules.nixos.linuxDesktop =
    { pkgs, ... }:
    {

      # https://nixos.wiki/wiki/Chromium
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      networking.networkmanager.enable = true;
      services.dbus.packages = with pkgs; [
        gcr
      ];
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
          hplip
        ];
      };
      services.fwupd.enable = true;
      programs.hyprlock.enable = true;
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

      };
      users.users.cladam = {
        extraGroups = [
          "networkmanager"
          "pipewire"
        ];
      };
      security.sudo.wheelNeedsPassword = false;
      security.polkit.enable = true;

      # programs.firefox.enable = true;

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
      services.blueman.enable = true;
      hardware.bluetooth.enable = true;
      programs.hyprland = {
        enable = true;
        withUWSM = true; # recommended for most users
        xwayland.enable = true; # Xwayland can be disabled.
      };
      # systemd.user.services.hypridle.path = with pkgs; [
      #   brightnessctl
      # ];
      security.pam.services.login.enableGnomeKeyring = true;
      programs.seahorse.enable = true;
      services.openssh.enable = true;
      networking.firewall.allowedTCPPorts = [
        57621 # spotify
      ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
    };

  flake.modules.homeManager.systemDesktop = {
    programs.wofi.enable = true;
  };
}
