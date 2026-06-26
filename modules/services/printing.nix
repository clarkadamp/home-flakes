{
  flake.modules.nixos.printing =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        system-config-printer
      ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };
}
