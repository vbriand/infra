{ inputs, ... }:
{
  flake-file.inputs = {
    alan-wake-mods = {
      url = "path:/mnt/games/mods/alan-wake";
      flake = false;
    };
  };

  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."108710" = {
      name = "Alan Wake";
      files.game = {
        place = {
          # Disable motion blur
          "shaders/build/pc".source = ./assets;
          ".".source = pkgs.stdenv.mkDerivation {
            pname = "alan-wake-remastered-cutscenes";
            version = "1.0";
            outputHash = "sha256-dv6A35g4+H5Lngruj9RUOj+q9q+st3XFIi82cPRH4sE=";
            outputHashAlgo = "sha256";
            outputHashMode = "nar";

            # https://www.nexusmods.com/alanwake/mods/12
            src = inputs.alan-wake-mods + "/remastered-cutscenes";

            nativeBuildInputs = [ pkgs.unzip ];

            dontBuild = true;
            dontFixup = true;

            unpackPhase = ''
              runHook preUnpack
              for zipfile in $src/*.zip; do
                unzip -q "$zipfile" -d "$out"
              done
              runHook postUnpack
            '';
          };
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
