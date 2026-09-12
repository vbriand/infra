{
  den,
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs = {
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix&ref=next";
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.steam = {
    includes = [
      den.aspects.boilr
      den.aspects.steam.games
    ];

    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.millennium.overlays.default ];

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
      };

      environment = {
        systemPackages = with pkgs; [
          samrewritten
        ];
      };
    };

    homeManager = { config, ... }: {
      imports = [
        inputs.steam-config-nix.homeModules.default
      ];

      # To find the internal name of a compatibility tool, one might manually
      # select it in the game's options, then open ~/.local/share/Steam/config/config.vdf
      # and search for the game's id in the "CompatToolMapping" object.
      programs.steam.config = {
        # Voir pour explorer une manière de définir les "launch options" dans apps.<id>.DefaultLaunchOption dans le fichier ~/.local/share/Steam/userdata/11938770/config/localconfig.vdf
        enable = true;
        onSteamRunning = "close";
        defaultCompatTool = "Proton-GE";
      };

      sops.templates."steam-easygrid/config.json" = {
        content = ''
          {
              "api_key": "${config.sops.placeholder."keys/api/sgdb"}",
              "display_name_fallback": true,
              "replace_custom_images": true,
              "appids_excluded_from_replacement": [],
              "prioritize_animated":  false,
              "expand_headers": "",
              "app_page_button": true,
              "grids_config": {
                  "nsfw": "false",
                  "humor": "any",
                  "epilepsy": "any",
                  "types": "static,animated",
                  "mimes": "image/webp,image/png,image/jpeg",
                  "styles": "alternate,blurred,white_logo,material,no_logo",
                  "dimensions": "600x900,342x482,660x930,512x512,1024x1024"
              },
              "wide_grids_config": {
                  "nsfw": "false",
                  "humor": "any",
                  "epilepsy": "any",
                  "types": "static,animated",
                  "mimes": "image/webp,image/png,image/jpeg",
                  "styles": "alternate,blurred,white_logo,material,no_logo",
                  "dimensions": "460x215,920x430,512x512,1024x1024"
              },
              "heroes_config": {
                  "nsfw": "false",
                  "humor": "any",
                  "epilepsy": "any",
                  "types": "static,animated",
                  "mimes": "image/webp,image/png,image/jpeg",
                  "styles": "alternate,blurred,material"
              },
              "logos_config": {
                  "nsfw": "false",
                  "humor": "any",
                  "epilepsy": "any",
                  "types": "static,animated",
                  "mimes": "image/webp,image/png",
                  "styles": "official,white,black,custom"
              },
              "icons_config": {
                  "nsfw": "false",
                  "humor": "any",
                  "epilepsy": "any",
                  "types": "static,animated",
                  "mimes": "image/png,image/vnd.microsoft.icon",
                  "styles": "official,custom"
              },
              "grids_width_mult": 5,
              "heroes_width_mult": 10,
              "logos_width_mult": 7
          }
        '';
        path = "${config.xdg.dataHome}/millennium/plugins/steam-easygrid/config.json";
      };
    };
  };
}
