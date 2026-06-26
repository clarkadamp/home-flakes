{ self, ... }: {
  flake.modules.nixos.keyboardRemaps = {
    imports = with self.modules.nixos; [
      homeRowMods
    ];
    services.kanata = {
      enable = false;
      keyboards.builtin.extraDefCfg = "process-unmapped-keys yes";
    };
  };
}
