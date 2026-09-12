{
  den.aspects.steam.games.homeManager = {
    programs.steam.config.apps."40800" = {
      name = "Super Meat Boy";
      # Native Linux version is selected by default but is obsolete (2010 version), thus Proton needs to be forced
      compatTool = "Proton-GE";
      args = [
        "-fullscreen"
        "-1920x1080"
      ];
    };
  };
}
