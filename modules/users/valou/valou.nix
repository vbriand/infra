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

  den.aspects.valou = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.audio.effects
      den.aspects.better-commits
      den.aspects.fish
      den.aspects.ghostty
      den.aspects.git
      den.aspects.nh
      den.aspects.kodi
      den.aspects.ludusavi
      den.aspects.plasma
      den.aspects.secrets
      den.aspects.syncthing
      den.aspects.vscode
      den.aspects.zen-browser
    ];

    user =
      { config, ... }:
      {
        hashedPasswordFile = config.sops.secrets."passwords/valou".path;
        extraGroups = [
          "gamemode" # TODO: find how to make it dependent on programs.gamemode.enable
          "i2c" # Same for hardware.i2c.enable
        ];
      };

    homeManager =
      { home, pkgs, ... }:
      {
        imports = [
          inputs.steam-config-nix.homeModules.default
        ];

        home.packages = with pkgs; [
          nixfmt

          # # It is sometimes useful to fine-tune packages, for example, by applying
          # # overrides. You can do that directly here, just don't forget the
          # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
          # # fonts?
          # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

          # # You can also create simple shell scripts directly inside your
          # # configuration. For example, this adds a command 'my-hello' to your
          # # environment:
          # (pkgs.writeShellScriptBin "my-hello" ''
          #   echo "Hello, ${config.home.username}!"
          # '')
        ];

        programs.steam.config = {
          enable = true;
          closeSteam = true;
          defaultCompatTool = "GE-Proton";
          apps = {
            bit-trip-runner = {
              id = 63710;
              compatTool = "proton_experimental";
            };
            borderlands-goty = {
              id = 8980;
              compatTool = "GE-Proton";
              launchOptionsStr = ''WINEDLLOVERRIDES="dsound=n,b" %command% -nostartupmovies -nosplash'';
            };
            counter-strike2 = {
              id = 730;
              launchOptionsStr = ''LD_PRELOAD="" gamemoderun gamescope -W 3440 -H 1440 -w 2560 -h 1440 -f -S stretch --force-grab-cursor --immediate-flips -r 165 --backend=wayland -- env LD_PRELOAD="$LD_PRELOAD" ENABLE_LAYER_MESA_ANTI_LAG="1" %command% -sdlaudiodriver pipewire'';
            };
            fallout-76 = {
              id = 1151340;
              compatTool = "GE-Proton";
              launchOptionsStr = "gamescope -w 3440 -h 1440 -f --force-grab-cursor -- %command%";
            };
            half-life-legacy = {
              id = 3619040;
              compatTool = "GE-Proton";
            };
            monster-hunter-world = {
              id = 582010;
              compatTool = "GE-Proton";
              launchOptions = {
                wrappers = [
                  # (lib.getExe pkgs.gamemode)
                  "gamemoderun"
                ];
              };
            };
            red-dead-redemption2 = {
              id = 1174180;
              compatTool = "GE-Proton";
            };
            slay-the-spire = {
              id = 646570;
              compatTool = "proton_experimental";
              launchOptionsStr = ''LD_PRELOAD="" gamescope -f -w 1920 -h 1080 -W 3440 -H 1440 -r 165 -- env LD_PRELOAD="$LD_PRELOAD" %command%'';
            };
            super-meat-boy = {
              id = 40800;
              compatTool = "GE-Proton";
              launchOptions = {
                args = [
                  "-fullscreen"
                  "-1920x1080"
                ];
              };
            };
          };
        };
      };

    # Enabled when host supports gaming role
    gaming =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [ inputs.millennium.overlays.default ];

        programs = {
          steam = {
            enable = true;
            package = pkgs.millennium-steam;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
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

    provides.hogwarts.nixos = {
      programs = {
        firefox.enable = true;
        thunderbird.enable = true;
      };
    };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
