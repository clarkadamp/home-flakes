{
  flake.modules.nixos.systemCli = {
    security.sudo.wheelNeedsPassword = false;
  };
  flake.modules.darwin.systemCli = {
    security.pam.services.sudo_local.touchIdAuth = true;
    security.sudo.extraConfig = ''
      %admin     ALL=(ALL) NOPASSWD:ALL
    '';
  };
}
