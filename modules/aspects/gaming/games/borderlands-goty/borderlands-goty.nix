{
  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."8980" = {
      name = "Borderlands GOTY";
      files = {
        game.place = {
          ".".source = pkgs.symlinkJoin {
            name = "borderlands_goty_sdk_mods";
            paths = [
              (pkgs.fetchzip {
                url = "https://github.com/bl-sdk/willow1-mod-manager/releases/download/v2.3/bl1-sdk.zip";
                hash = "sha256-zEoaFir6Wuy9H8iKbchnoksJKSW/wrbyFmxSH3DxMd8=";
                stripRoot = false;
              })
              (pkgs.fetchzip {
                url = "https://github.com/MOW531/MOW531-BL1-SDK-Mods/raw/refs/heads/main/Permanent%20FOV%20and%20sprint%20rotation%20fix/FOV%20and%20sprint%20rotation%20fix.zip";
                hash = "sha256-EQ8J92TJb91rAxdl2tARpo0JJSILrxLmHWo6Unw3sK0=";
                stripRoot = false;
              })
            ];
          };
          "sdk_mods/settings/FOV.json" = {
            source = ./assets/FOV.json;
            mode = "seed";
          };
        };
        prefix.patch = {
          "drive_c/users/steamuser/Documents/my games/borderlands/WillowGame/Config/WillowEngine.ini" = {
            format = "ini";
            content = {
              "Engine.GameEngine" = {
                bSmoothFrameRate = "True";
                MinSmoothedFrameRate = 22;
                MaxSmoothedFrameRate = 165;
              };
              SystemSettings = {
                Fullscreen = "True";
                MaxShadowResolution = 4096;
                ResX = 3440;
                ResY = 1440;
              };
            };
          };
          "drive_c/users/steamuser/Documents/my games/borderlands/WillowGame/Config/WillowInput.ini" = {
            format = "ini";
            content = {
              "Engine.Console".ConsoleKey = "F9";
              "Engine.PlayerInput".bEnableMouseSmoothing = "False";
            };
          };
        };
      };
      dllOverrides.dsound = "n,b";
      args = [
        "-nostartupmovies"
        "-nosplash"
      ];
    };
  };
}
