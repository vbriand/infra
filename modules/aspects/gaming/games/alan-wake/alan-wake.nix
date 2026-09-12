{
  den.aspects.steam.games.homeManager = {
    programs.steam.config.apps."108710" = {
      name = "Alan Wake";
      files.game = {
        place = {
          # Disable motion blur
          "shaders/build/pc".source = ./assets;
        };
        remove = [
          # Remove startup videos
          "data/videos/startup_mgs.bik"
          "data/videos/startup_remedy.bik"
        ];
      };
    };
  };
}
