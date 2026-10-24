{
  flake.modules.nixos.androidDevices =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # MTP mounts
        # jmtpfs
        pkgs.unfree.jocalsend
      ];
      programs = {
        fuse = {
          enable = true;
          userAllowOther = true;
        };
        localsend = {
          enable = true;
          openFirewall = true;
        };
      };
      users.users.cladam.extraGroups = [ "adbusers" ];
      home-manager.sharedModules = [
        {
          wayland.windowManager.hyprland = {
            settings = {
              window_rule = [
                {
                  name = "localsend-float";
                  match = {
                    class = "localsend_app";
                  };
                  float = true;
                  pin = true;
                  # size = [
                  #   "(monitor_w*0.8)"
                  #   "(monitor_h*0.8)"
                  # ];
                }

              ];
            };
          };
        }
      ];
    };

}
# vim: ts=2 sts=2 sw=2 et
