{
  den.aspects.steam.games.homeManager = {
    programs.steam.config.apps."202750" = {
      name = "Alan Wake's American Nightmare";
      files.game = {
        remove = [
          # Remove startup video
          "data/videos/startup_remedy.bik"
        ];
      };
    };
  };
}
