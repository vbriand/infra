{ lib, ... }:
{
  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."730" = {
      name = "Counter-Strike 2";
      env.ENABLE_LAYER_MESA_ANTI_LAG = "1";
      wrappers = [
        (lib.getExe pkgs.gamescope)
        "-W"
        "3440"
        "-H"
        "1440"
        "-w"
        "2560"
        "-h"
        "1440"
        "-f"
        "-S"
        "stretch"
        "--force-grab-cursor"
        "--immediate-flips"
        "--backend"
        "wayland"
        "-O"
        "DP-1"
        "--"
        "gamemoderun"
      ];
      args = [
        "-sdlaudiodriver"
        "pipewire"
      ];
    };
  };
}
