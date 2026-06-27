{ den, inputs, ... }:
{
  flake-file.inputs = {
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix&ref=next";
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.gaming = {
    includes = [ den.aspects.ludusavi ];

    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.millennium.overlays.default ];

      boot.kernelModules = [ "ntsync" ];

      environment = {
        systemPackages = with pkgs; [
          boilr
          heroic
          protonplus
          samrewritten
        ];
      };

      programs = {
        steam = {
          enable = true;
          package = pkgs.millennium-steam;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
          localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
          extraCompatPackages = with pkgs; [
            proton-ge-custom
            steamtinkerlaunch
          ];
        };
        gamemode = {
          enable = true;
          enableRenice = true;
          settings = {
            general = {
              softrealtime = "auto";
              renice = 10;
            };
            custom = {
              start = with pkgs; [
                "${lib.getExe ddcutil} -d 1 setvcp 10 90"
                "${lib.getExe power-profiles-daemon} set performance"
                "${lib.getExe libnotify} 'GameMode started'"
              ];
              end = with pkgs; [
                "${lib.getExe libnotify} 'GameMode ended'"
                "${lib.getExe power-profiles-daemon} set balanced"
                "${lib.getExe ddcutil} -d 1 setvcp 10 44"
              ];
            };
          };
        };
        gamescope.enable = true;
      };

      services = {
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
        };
      };
    };

    homeManager = { config, ... }: {
      imports = [
        inputs.steam-config-nix.homeModules.default
      ];

      programs.steam.config = {
        enable = true;
        closeSteam = true;
        defaultCompatTool = "Proton-GE";
        apps = {
          bit-trip-runner = {
            id = 63710;
            compatTool = "proton_experimental";
          };
          borderlands-goty = {
            id = 8980;
            compatTool = "Proton-GE";
            launchOptionsStr = ''WINEDLLOVERRIDES="dsound=n,b" %command% -nostartupmovies -nosplash'';
          };
          counter-strike2 = {
            id = 730;
            launchOptionsStr = ''LD_PRELOAD="" gamemoderun gamescope -W 3440 -H 1440 -w 2560 -h 1440 -f -S stretch --force-grab-cursor --immediate-flips -r 165 --backend=wayland -- env LD_PRELOAD="$LD_PRELOAD" ENABLE_LAYER_MESA_ANTI_LAG="1" %command% -sdlaudiodriver pipewire'';
          };
          fallout-76 = {
            id = 1151340;
            compatTool = "Proton-GE";
            launchOptionsStr = "gamescope -w 3440 -h 1440 -f --force-grab-cursor -- %command%";
          };
          half-life-legacy = {
            id = 3619040;
            compatTool = "Proton-GE";
          };
          monster-hunter-world = {
            id = 582010;
            compatTool = "Proton-GE";
            launchOptions = {
              wrappers = [
                # (lib.getExe pkgs.gamemode)
                "gamemoderun"
              ];
            };
          };
          red-dead-redemption2 = {
            id = 1174180;
            compatTool = "Proton-GE";
          };
          slay-the-spire = {
            id = 646570;
            compatTool = "proton_experimental";
            launchOptionsStr = ''LD_PRELOAD="" gamescope -f -w 1920 -h 1080 -W 3440 -H 1440 -r 165 -- env LD_PRELOAD="$LD_PRELOAD" %command%'';
          };
          super-meat-boy = {
            id = 40800;
            compatTool = "Proton-GE";
            launchOptions = {
              args = [
                "-fullscreen"
                "-1920x1080"
              ];
            };
          };
        };
      };

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
