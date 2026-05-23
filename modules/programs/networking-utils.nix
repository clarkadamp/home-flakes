{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      networkingUtils
    ];
  };
in
{
  flake.modules.nixos.networkingUtils = {
    inherit home-manager;
  };

  flake.modules.darwin.networkingUtils = {
    inherit home-manager;
  };

  flake.modules.homeManager.networkingUtils =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # bind
        curl
        dig
        inetutils
        netcat
        nettools
        socat
        tcpdump
        wget
      ];
    };
}
