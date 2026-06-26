{
  flake.modules.nixos.homeRowMods = { lib, ... }: {
    services.kanata.keyboards.builtin.config = lib.mkOrder 500 ''
      ;; defsrc is still necessary
      (defsrc
        caps pgup pgdn a s d f j k l ;
      )
      (defvar
        tap-time 150
        hold-time 200
      )

      (defalias
        a (multi f24 (tap-hold $tap-time $hold-time a lsft))
        s (multi f24 (tap-hold $tap-time $hold-time s lctl))
        d (multi f24 (tap-hold $tap-time $hold-time d lmet))
        f (multi f24 (tap-hold $tap-time $hold-time f lalt))
        j (multi f24 (tap-hold $tap-time $hold-time j ralt))
        k (multi f24 (tap-hold $tap-time $hold-time k rmet))
        l (multi f24 (tap-hold $tap-time $hold-time l rctl))
        ; (multi f24 (tap-hold $tap-time $hold-time ; rsft))
      )

      (deflayer base
        esc XX XX @a @s @d @f @j @k @l @;
      )
      ;; (defsrc
      ;;  caps esc)

      ;;(deflayermap (default-layer)
      ;;  caps esc
      ;;)
    '';
  };
}
