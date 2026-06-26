{ self, ... }:
let
  home-manager = {
    sharedModules = with self.modules.homeManager; [
      ssh
    ];
  };
in
{
  flake.modules.nixos.ssh = {
    inherit home-manager;
    programs.ssh.startAgent = true;
  };

  flake.modules.darwin.ssh = {
    inherit home-manager;
  };

  flake.modules.homeManager.ssh =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        openssh
      ];
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            IdentityFile = lib.mkDefault "~/.ssh/id_ed25519";
            SetEnv = {
              TERM = "xterm-256color";
            };
            ForwardAgent = true;
            AddKeysToAgent = true;
            ServerAliveInterval = 15;
            ServerAliveCountMax = 44;
            Compression = true;
          };
        };
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
