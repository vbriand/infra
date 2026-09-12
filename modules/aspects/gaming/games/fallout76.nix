{ lib, ... }:
{
  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."1151340" = {
      name = "Fallout 76";
      wrappers = [
        (lib.getExe pkgs.gamescope)
        "-w"
        "3440"
        "-h"
        "1440"
        "-f"
        "--force-grab-cursor"
        "--"
        "gamemoderun"
      ];
    };
  };
}
