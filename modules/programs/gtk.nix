{ self, ... }: {
  flake.modules.nixos.gtk = {
    home-manager = {
      sharedModules = with self.modules.homeManager; [
        gtk
      ];
    };
  };

  flake.modules.homeManager.gtk =
    { pkgs, ... }:
    let
      adw-colors = pkgs.fetchFromGitHub {
        owner = "lassekongo83";
        repo = "adw-colors";
        # v6.5
        rev = "47922ed96562c002696ad2d2d80383f2ad30dc93";
        sha256 = "sha256-WCG662t3EWk6FFJxm4rmz7h/d10il4YUvLKeTBK+Tvs=";
      };
      adw-solarized = "${adw-colors}/themes/adw-solarized";
    in
    {
      home.packages = with pkgs; [
        adw-gtk3
        nwg-look
      ];
      gtk = {
        enable = true;
        theme = {
          # name = "SolArc-Dark";
          # package = pkgs.solarc-gtk-theme;
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4 = {
          theme = null;
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };
      xdg.configFile.scratch.text = "${adw-colors}";
      xdg.configFile = {
        "gtk-3.0/gtk.css".source = "${adw-solarized}/gtk3-dark.css";
        "gtk-3.0/gtk-dark.css".source = "${adw-solarized}/gtk3-dark.css";

        "gtk-4.0/gtk.css".source = "${adw-solarized}/gtk4-dark.css";
        "gtk-4.0/gtk-dark.css".source = "${adw-solarized}/gtk4-dark.css";
      };
    };
}
# vim: ts=2 sts=2 sw=2 et
