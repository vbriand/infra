{ den, ... }:
{
  den.aspects.ludusavi.base = {
    homeManager = {
      services.ludusavi.enable = true;
    };
  };

  den.aspects.ludusavi.daily-backup = {
    includes = [ den.aspects.ludusavi.base ];

    homeManager = { config, ... }: {
      services.ludusavi = {
        backupNotification = true;
        frequency = "*-*-* 22:00:00";
        settings = {
          backup.path = "${config.xdg.stateHome}/backups/ludusavi";
          language = "en-US";
          restore.path = "${config.xdg.stateHome}/backups/ludusavi";
          roots = [
            {
              path = "${config.xdg.dataHome}/Steam";
              store = "steam";
            }
            {
              path = "${config.xdg.configHome}/heroic";
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
