{
  flake.modules.homeManager.dotfilesRoot =
    { lib, ... }:
    let
      inherit (lib)
        mkOption
        types
        ;
    in
    {
      options.dotfilesRoot = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };

    };
}
