{ lib, ... }:
let
  modsDir = "/mnt/games/mods/alan-wakes-american-nightmare";
in
{
  den.aspects.steam.games.homeManager = { config, pkgs, ... }: {
    # https://www.nexusmods.com/alanwakesamericannightmare/mods/6
    home.activation.extractAlanWakesAmericanNightmareCutscenes =
      config.lib.dag.entryAfter [ "writeBoundary" ]
        ''
          extracted="${modsDir}/extracted/upscaled-cinematics"
          if [ ! -f "$extracted/.done" ]; then
            zipfile="${modsDir}/Upscaled Cinematics (HEAVY Version)-6-1-00-1738783601.zip"
            run mkdir -p "$extracted"
            run ${lib.getExe pkgs.unzip} -q -o "$zipfile" -d "$extracted"
            run touch "$extracted/.done"
          fi
        '';

    programs.steam.config.apps."202750" = {
      name = "Alan Wake's American Nightmare";
      files.game = {
        place = {
          ".".source = config.lib.file.mkOutOfStoreSymlink "${modsDir}/extracted/upscaled-cinematics";
        };
        remove = [
          # Remove startup video
          "data/videos/startup_remedy.bik"
        ];
      };
    };
  };
}
