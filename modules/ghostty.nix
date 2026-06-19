{
  den.aspects.ghostty = {
    nixos = { pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [ ghostty ];
      };
    };

    homeManager = {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true; # TODO: enable only when fish is used.
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-enable-primary-paste = true;
          };
        };
      };
    };

    provides.valou.homeManager = {
      programs.ghostty = {
        settings = {
          theme = "Synthwave";
        };
      };
    };
  };
}
