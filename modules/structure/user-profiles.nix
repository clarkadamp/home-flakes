{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
  userProfile = types.submodule {
    options = {
      email = mkOption { type = types.str; };
      fullName = mkOption { type = types.str; };
      username = mkOption { type = types.str; };
    };
  };
  userProfileOption = mkOption {
    type = userProfile;
    default = { };
  };
  userProfilesOption = mkOption {
    type = types.attrsOf userProfile;
    default = { };
  };
in
{
  options.flake.meta.users = userProfilesOption;
  config.flake.modules = {
    nixos.base.options.userProfile = userProfileOption;
    homeManager.base.options.userProfile = userProfileOption;
  };
}
