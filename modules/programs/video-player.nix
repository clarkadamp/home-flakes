{ self, ... }:
{
  flake.modules.nixos.videoPlayer =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vlc
      ];
    };

  flake.modules.darwin.videoPlayer =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
      ];
      imports = with self.modules.darwin; [ homebrew ];
      homebrew = {
        casks = [
          "vlc"
        ];
      };
    };

}
# vim: ts=2 sts=2 sw=2 et
