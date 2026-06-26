{ self, ... }:
{
  flake.modules.nixos.videoPlayer = {
    home-manager.sharedModules = with self.modules.homeManager; [
      videoPlayer
    ];
  };

  flake.modules.darwin.videoPlayer = {
    imports = with self.modules.darwin; [ homebrew ];
    homebrew = {
      casks = [
        "vlc"
      ];
    };
  };

  flake.modules.homeManager.videoPlayer =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vlc
      ];
    };

}
# vim: ts=2 sts=2 sw=2 et
