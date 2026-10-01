{ lib, ... }:
let
  modsDir = "/mnt/games/mods/alan-wake";
in
{
  den.aspects.steam.games.homeManager = { config, pkgs, ... }: {
    # https://www.nexusmods.com/alanwake/mods/12
    home.activation.extractAlanWakeCutscenes = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      extracted="${modsDir}/extracted/remastered-cutscenes"
      if [ ! -f "$extracted/.done" ]; then
        $DRY_RUN_CMD mkdir -p "$extracted"
        for zipfile in "${modsDir}/remastered-cutscenes/"*.zip; do
          $DRY_RUN_CMD ${lib.getExe pkgs.unzip} -q -o "$zipfile" -d "$extracted"
        done
        $DRY_RUN_CMD touch "$extracted/.done"
      fi
    '';

    programs.steam.config.apps."108710" = {
      name = "Alan Wake";
      files.game = {
        place = {
          # Disable motion blur
          "shaders/build/pc".source = ./assets;
          ".".source = config.lib.file.mkOutOfStoreSymlink "${modsDir}/extracted/remastered-cutscenes";
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
