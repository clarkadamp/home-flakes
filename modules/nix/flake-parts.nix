{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options = {
    flake.factory = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
  };

  config.flake.factory = {
    # Helper: create a NixOS configuration from a module name
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };
    # Helper: create a Darwin configuration from a module name
    mkDarwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };
    # Helper: create a standalone Home Manager configuration
    mkHome = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ inputs.self.modules.homeManager.${name} ];
      };
    };
  };

  config.flake = {
    darwinModules = config.flake.modules.darwin;
    homeModules = config.flake.modules.homeManager;
    nixosModules = config.flake.modules.nixos;
  };
}
