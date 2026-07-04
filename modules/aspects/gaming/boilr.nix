{
  den.aspects.boilr = {
    nixos = { pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [
          boilr
        ];
      };
    };

    homeManager = { config, ... }: {
      sops.templates."boilr/config.toml" = {
        content = ''
          debug = false
          config_version = 1
          blacklisted_games = [3465099058, 3189141097, 2359371798, 3459535138, 3863540611, 2901383340, 3703033866, 3851515050, 3262922216, 3903359044]

          [steamgrid_db]
          enabled = true
          auth_key = "${config.sops.placeholder."keys/api/sgdb"}"
          prefer_animated = false
          banned_images = []
          only_download_boilr_images = false
          allow_nsfw = false

          [steam]
          create_collections = false
          optimize_for_big_picture = false
          stop_steam = true
          start_steam = true

          [bottles]
          enabled = true

          [epic_games]
          enabled = false
          safe_launch = []

          [flatpak]
          enabled = false

          [gog]
          enabled = false
          create_symlinks = true

          [heroic]
          enabled = true
          launch_games_through_heroic = []
          default_launch_through_heroic = true

          [itch]
          enabled = false
          create_symlinks = true

          [legendary]
          enabled = false

          [lutris]
          enabled = false
          executable = "lutris"
          flatpak = true
          flatpak_image = "net.lutris.Lutris"
          installed = true

          [origin]
          enabled = false

          [uplay]
          enabled = false

          [minigalaxy]
          enabled = false
          create_symlinks = false
        '';
        path = "${config.xdg.configHome}/boilr/config.toml";
      };
    };
  };
}
