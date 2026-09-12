{
  den.aspects.steam.games.homeManager = {
    programs.steam.config.apps."3830" = {
      name = "Psychonauts";
      compatTool = "Proton-GE";
      # https://www.pcgamingwiki.com/wiki/Psychonauts#Steam_Cloud_not_working_(Linux)
      env.XDG_DATA_HOME = "/mnt/games/SteamLibrary/steamapps/common";
      files.game = {
        remove = [
          # Remove startup video
          "WorkResource/Cutscenes/Prerendered/DFLogo.bik"
        ];
      };
    };
  };
}
