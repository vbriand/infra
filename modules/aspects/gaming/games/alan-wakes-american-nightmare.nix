{ inputs, ... }:
{
  flake-file.inputs = {
    alan-wakes-american-nightmare-mods = {
      url = "path:/mnt/games/mods/alan-wakes-american-nightmare";
      flake = false;
    };
  };

  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."202750" = {
      name = "Alan Wake's American Nightmare";
      files.game = {
        place = {
          ".".source = pkgs.stdenv.mkDerivation {
            pname = "alan-wakes-american-nightmare-upscaled-cinematics";
            version = "1.0";
            outputHash = "sha256-nkhf+a2r8xyOKoIhhuAlKxbgOa+6uLBYs9r/3ODq6Io=";
            outputHashAlgo = "sha256";
            outputHashMode = "nar";

            # https://www.nexusmods.com/alanwakesamericannightmare/mods/6
            src =
              inputs.alan-wakes-american-nightmare-mods
              + "/Upscaled Cinematics (HEAVY Version)-6-1-00-1738783601.zip";

            nativeBuildInputs = [ pkgs.unzip ];

            dontBuild = true;
            dontFixup = true;

            unpackPhase = ''
              runHook preUnpack
              unzip -q "$src" -d "$out"
              runHook postUnpack
            '';
          };
        };
        remove = [
          # Remove startup video
          "data/videos/startup_remedy.bik"
        ];
      };
    };
  };
}
