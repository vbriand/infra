{
  den.aspects.ludusavi = {
    homeManager = {
      services.ludusavi.enable = true;
    };

    provides.valou.homeManager = {
      services.ludusavi = {
        backupNotification = true;
        frequency = "*-*-* 22:00:00";
        settings = {
          backup.path = "~/.local/state/backups/ludusavi";
          language = "en-US";
          restore.path = "~/.local/state/backups/ludusavi";
          roots = [
            {
              path = "~/.local/share/Steam";
              store = "steam";
            }
            {
              path = "~/.config/heroic";
              store = "heroic";
            }
            {
              # TODO centralize with fileSystems if possible
              path = "/mnt/games/SteamLibrary";
              store = "steam";
            }
          ];
          theme = "dark";
        };
      };
    };
  };
}
