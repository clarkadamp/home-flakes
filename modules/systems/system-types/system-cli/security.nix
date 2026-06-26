{
  flake.modules.nixos.systemCli = {
    services.openssh.enable = true;
    security = {
      polkit.enable = true;
      sudo.wheelNeedsPassword = false;
    };
  };
}
