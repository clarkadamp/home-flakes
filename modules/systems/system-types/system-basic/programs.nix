{ inputs, ... }:
{
  flake.modules.nixos.systemBasic =
    { pkgs, ... }:
    {
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      environment.systemPackages = with pkgs; [
        (writeShellApplication {
          name = "nx-switch";
          text = ''nixos-rebuild switch --sudo --flake ~/system-flakes "''${@}"'';
        })
        parted
        pciutils
        systemctl-tui
      ];
    };

  flake.modules.darwin.systemBasic = {
  };

  flake.modules.homeManager.systemBasic =
    { pkgs, ... }:
    {
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      home.packages = with pkgs; [
        git
        jq
        lsof
        vim
      ];

    };
}
