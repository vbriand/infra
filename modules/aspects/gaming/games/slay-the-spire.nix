{ lib, ... }:
{
  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."646570" = {
      name = "Slay the Spire";
      compatTool = "steamlinuxruntime";
      wrappers = [
        (lib.getExe pkgs.gamescope)
        "-W"
        "3440"
        "-H"
        "1440"
        "-w"
        "1920"
        "-h"
        "1080"
        "-f"
        "--"
        "gamemoderun"
      ];
    };
  };
}
