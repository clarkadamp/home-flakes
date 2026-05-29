{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      systemEssential
    ];
  };
in
{
  flake.modules.nixos.systemEssential =
    { lib, ... }:
    {
      inherit home-manager;
      system.stateVersion = lib.mkDefault "25.11";
    };

  flake.modules.darwin.systemEssential =
    { lib, ... }:
    {
      inherit home-manager;
      system.stateVersion = lib.mkDefault 7;
    };

  flake.modules.homeManager.systemEssential =
    { lib, ... }:
    {
      home.stateVersion = lib.mkDefault "25.11";
    };
}
