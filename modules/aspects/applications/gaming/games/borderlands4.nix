{
  den.aspects.applications.games.homeManager = {
    programs.steam.config.apps."1285190" = {
      name = "Borderlands 4";
      wrappers = [ "gamemoderun" ];
      args = [
        "-nostartupmovies"
      ];
    };
  };
}
