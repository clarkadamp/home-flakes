{
  flake.modules.nixos.systemCli = {
    security.sudo.wheelNeedsPassword = false;
  };
}
