{ self, ... }:
{
  flake.modules.nixos.audio = {
    home-manager.sharedModules = with self.modules.homeManager; [
      audio
    ];
    users.users.cladam = {
      extraGroups = [
        "pipewire"
      ];
    };
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  flake.modules.homeManager.audio =
    { lib, pkgs, ... }:
    let
      inherit (self.factory.hyprland)
        bind''
        ;
    in
    {
      home.packages = with pkgs; [
        sof-firmware
        playerctl
      ];
      wayland.windowManager.hyprland.settings = {
        bind = lib.lists.flatten [
          (bind'' "XF86AudioRaiseVolume" "exec_cmd" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" {
            locked = true;
            repeating = true;
          })
          (bind'' "XF86AudioLowerVolume" "exec_cmd" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" {
            locked = true;
            repeating = true;
          })
          (bind'' "XF86AudioMute" "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" {
            locked = true;
            repeating = true;
          })
          (bind'' "XF86AudioMicMute" "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" {
            locked = true;
            repeating = true;
          })

          # Requires playerctl
          (bind'' "XF86AudioNext" "exec_cmd" "playerctl next" { locked = true; })
          (bind'' "XF86AudioPause" "exec_cmd" "playerctl play-pause" { locked = true; })
          (bind'' "XF86AudioPlay" "exec_cmd" "playerctl play-pause" { locked = true; })
          (bind'' "XF86AudioPrev" "exec_cmd" "playerctl previous" { locked = true; })
        ];
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
