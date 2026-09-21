{ inputs, lib, ... }:
{
  flake-file.inputs = {
    mods = {
      url = "path:/mnt/games/mods";
      flake = false;
    };
  };

  den.aspects.steam.games.homeManager = { pkgs, ... }: {
    programs.steam.config.apps."3830" = {
      name = "Psychonauts";
      compatTool = "Proton-GE";
      # https://www.pcgamingwiki.com/wiki/Psychonauts#Steam_Cloud_not_working_(Linux)
      env.XDG_DATA_HOME = "/mnt/games/SteamLibrary/steamapps/common";
      files.game = {
        place = {
          ".".source = pkgs.fetchurl {
            url = "https://gitlab.com/-/project/34250039/uploads/6f9bb111143e042a49c23e0f79bb38df/Astralathe-master-24fbe2d7.zip";
            hash = "sha256-QVgkO2lSzIKvIqD8zQ9hs4Cu/PlgCKkSxXElbkPhzsc=";
            recursiveHash = true;
            downloadToTemp = true;
            nativeBuildInputs = [ pkgs.p7zip ];

            # The zip contains out-of-spec Windows backslashes for paths that fetchzip can't
            # process, so we need to replace them with proper forward slashes before extracting it
            postFetch = ''
              # "7z rn" doesn't work if the zip file doesn't have an extension, so we need to add
              # one as downloadToTemp = true; names $downloadedFile as "$TMPDIR/file"
              renamed="$TMPDIR/$downloadedFile.zip"
              mv "$downloadedFile" "$renamed"
              pairs=$(7z l "$renamed" | awk '{ n=$6 } n ~ /\\/ && n !~ /\\$/ { print n, gensub(/\\/,"/","g",n) }' | paste -s)
              if [ -n "$pairs" ]; then
                  7z rn "$renamed" $pairs
              fi
              7z x "$renamed" -o"$out" -y
              chmod 755 "$out"
            '';
          };
          "ModResource".source = pkgs.stdenv.mkDerivation {
            pname = "shibanauts-hd-mod";
            version = "2026-09-10";

            # https://www.nexusmods.com/psychonauts/mods/21
            src = inputs.mods + "/psychonauts/Shibanauts HD Mod 21 6 2026-09-10T06-56Z tCH1DH9zc.7z";

            nativeBuildInputs = [ pkgs.p7zip ];

            dontBuild = true;
            dontFixup = true;

            unpackPhase = ''
              runHook preUnpack
              7z x "$src" -o"$out" -y
              runHook postUnpack
            '';
          };
          "AudioSettings.ini".text = ''
            [AudioSettings]
            MasterVolume=1.000000
            FXVolume=1.000000
            MusicVolume=0.694123
            VoiceVolume=1.000000
            ShowSubtitles=false
            HardwareAccel=true
            UseEAX=false
            PacketSize=250
            MusicPacketSize=375
            PreloadVoice=true
          '';
          "DisplaySettings.ini".text = ''
            [DisplaySettings]
            ScreenWidth=6880
            ScreenHeight=2880
            FullScreen=true
            VSync=true
            FSAA=false
            FSFX=true
            AdvancedShading=true
            Shadows=true
            GammaCorrection=1.000000
          '';
        }
        // (
          let
            defaultCutscenesPaths = [
              "WorkResource/Cutscenes/Prerendered/ASAH.bik"
              "WorkResource/Cutscenes/Prerendered/ASCA.bik"
              "WorkResource/Cutscenes/Prerendered/ASCD.bik"
              "WorkResource/Cutscenes/Prerendered/ASEB_lose.bik"
              "WorkResource/Cutscenes/Prerendered/ASEB_win.bik"
              "WorkResource/Cutscenes/Prerendered/ASEE_lose.bik"
              "WorkResource/Cutscenes/Prerendered/ASEE_win.bik"
              "WorkResource/Cutscenes/Prerendered/ASEF_lose.bik"
              "WorkResource/Cutscenes/Prerendered/ASEF_win.bik"
              "WorkResource/Cutscenes/Prerendered/ASEG_lose.bik"
              "WorkResource/Cutscenes/Prerendered/ASEG_win.bik"
              "WorkResource/Cutscenes/Prerendered/ASET.bik"
              "WorkResource/Cutscenes/Prerendered/ASIB.bik"
              "WorkResource/Cutscenes/Prerendered/asie.bik"
              "WorkResource/Cutscenes/Prerendered/ASIF.bik"
              "WorkResource/Cutscenes/Prerendered/ASIG.bik"
              "WorkResource/Cutscenes/Prerendered/ASIN.bik"
              "WorkResource/Cutscenes/Prerendered/ASLS.bik"
              "WorkResource/Cutscenes/Prerendered/ASLV.bik"
              "WorkResource/Cutscenes/Prerendered/ASSH.bik"
              "WorkResource/Cutscenes/Prerendered/ASSP.bik"
              "WorkResource/Cutscenes/Prerendered/ASWV.bik"
              "WorkResource/Cutscenes/Prerendered/BBLI.bik"
              "WorkResource/Cutscenes/Prerendered/BullTossRaz_Rt.bik"
              "WorkResource/Cutscenes/Prerendered/BVDO.bik"
              "WorkResource/Cutscenes/Prerendered/bvin.bik"
              "WorkResource/Cutscenes/Prerendered/BVOT.bik"
              "WorkResource/Cutscenes/Prerendered/BVVI.bik"
              "WorkResource/Cutscenes/Prerendered/CABD.bik"
              "WorkResource/Cutscenes/Prerendered/CABV.bik"
              "WorkResource/Cutscenes/Prerendered/CAEC_lose.bik"
              "WorkResource/Cutscenes/Prerendered/CAEC_win.bik"
              "WorkResource/Cutscenes/Prerendered/CAEM_lose.bik"
              "WorkResource/Cutscenes/Prerendered/CAEM_win.bik"
              "WorkResource/Cutscenes/Prerendered/CAIM.bik"
              "WorkResource/Cutscenes/Prerendered/CAIO_2.bik"
              "WorkResource/Cutscenes/Prerendered/CAIO.bik"
              "WorkResource/Cutscenes/Prerendered/CALD.bik"
              "WorkResource/Cutscenes/Prerendered/CALK.bik"
              "WorkResource/Cutscenes/Prerendered/CALP.bik"
              "WorkResource/Cutscenes/Prerendered/CALU.bik"
              "WorkResource/Cutscenes/Prerendered/CANI.bik"
              "WorkResource/Cutscenes/Prerendered/CASR.bik"
              "WorkResource/Cutscenes/Prerendered/ClairVis_Archway.bik"
              "WorkResource/Cutscenes/Prerendered/ClairVis_Guitar.bik"
              "WorkResource/Cutscenes/Prerendered/ClairVis_Rose.bik"
              "WorkResource/Cutscenes/Prerendered/ClairVis_TikiHut.bik"
              "WorkResource/Cutscenes/Prerendered/ClairVis_Vine.bik"
              "WorkResource/Cutscenes/Prerendered/clairvoyancemeritbadge.bik"
              "WorkResource/Cutscenes/Prerendered/confusionmeritbadge.bik"
              "WorkResource/Cutscenes/Prerendered/DFLogo.bik"
              "WorkResource/Cutscenes/Prerendered/Dracogen.bik"
              "WorkResource/Cutscenes/Prerendered/FINI.bik"
              "WorkResource/Cutscenes/Prerendered/FirestartingMeritBadge.bik"
              "WorkResource/Cutscenes/Prerendered/Gameplay.bik"
              "WorkResource/Cutscenes/Prerendered/INTRO.bik"
              "WorkResource/Cutscenes/Prerendered/InvisibilityMeritBadge.bik"
              "WorkResource/Cutscenes/Prerendered/LevitationMeritBadge.bik"
              "WorkResource/Cutscenes/Prerendered/LLBF.bik"
              "WorkResource/Cutscenes/Prerendered/LLBT.bik"
              "WorkResource/Cutscenes/Prerendered/LLEL_lose.bik"
              "WorkResource/Cutscenes/Prerendered/LLEL_win.bik"
              "WorkResource/Cutscenes/Prerendered/LLIL.bik"
              "WorkResource/Cutscenes/Prerendered/LLLV.bik"
              "WorkResource/Cutscenes/Prerendered/lo_breakingnews.bik"
              "WorkResource/Cutscenes/Prerendered/LOIN.bik"
              "WorkResource/Cutscenes/Prerendered/louc.bik"
              "WorkResource/Cutscenes/Prerendered/LOVE.bik"
              "WorkResource/Cutscenes/Prerendered/LOZ1.bik"
              "WorkResource/Cutscenes/Prerendered/LOZ2.bik"
              "WorkResource/Cutscenes/Prerendered/MajescoLogo.bik"
              "WorkResource/Cutscenes/Prerendered/marksmanshipbadge.bik"
              "WorkResource/Cutscenes/Prerendered/MCBI.bik"
              "WorkResource/Cutscenes/Prerendered/MCFU.bik"
              "WorkResource/Cutscenes/Prerendered/MCVI.bik"
              "WorkResource/Cutscenes/Prerendered/MMDD.bik"
              "WorkResource/Cutscenes/Prerendered/MMDF.bik"
              "WorkResource/Cutscenes/Prerendered/MMDM.bik"
              "WorkResource/Cutscenes/Prerendered/NIBL.bik"
              "WorkResource/Cutscenes/Prerendered/NICE.bik"
              "WorkResource/Cutscenes/Prerendered/NID1.bik"
              "WorkResource/Cutscenes/Prerendered/NID2.bik"
              "WorkResource/Cutscenes/Prerendered/nien.bik"
              "WorkResource/Cutscenes/Prerendered/NIIN.bik"
              "WorkResource/Cutscenes/Prerendered/nivi.bik"
              "WorkResource/Cutscenes/Prerendered/RazOnBull.bik"
              "WorkResource/Cutscenes/Prerendered/saco.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Caulder2Shoe.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Crib2Caulder.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face1.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face1_implosion.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face2.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face2_implosion.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face3.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face3_implosion.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face6.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Face6_implosion.bik"
              "WorkResource/Cutscenes/Prerendered/SACU_Shoe2Factory.bik"
              "WorkResource/Cutscenes/Prerendered/SAES_lose.bik"
              "WorkResource/Cutscenes/Prerendered/SAES_win.bik"
              "WorkResource/Cutscenes/Prerendered/SAIN_1.bik"
              "WorkResource/Cutscenes/Prerendered/SAIN_2.bik"
              "WorkResource/Cutscenes/Prerendered/SAIS.bik"
              "WorkResource/Cutscenes/Prerendered/SAMC.bik"
              "WorkResource/Cutscenes/Prerendered/SLAC.bik"
              "WorkResource/Cutscenes/Prerendered/SLBT.bik"
              "WorkResource/Cutscenes/Prerendered/SLIN_1.bik"
              "WorkResource/Cutscenes/Prerendered/slin3.bik"
              "WorkResource/Cutscenes/Prerendered/TelekinesisMeritBadge.bik"
              "WorkResource/Cutscenes/Prerendered/THBF.bik"
              "WorkResource/Cutscenes/Prerendered/THBI.bik"
              "WorkResource/Cutscenes/Prerendered/THFP.bik"
              "WorkResource/Cutscenes/Prerendered/transgaming.bik"
            ];

            hdCutscenesPaths = pkgs.stdenv.mkDerivation {
              pname = "shibanauts-hd-cutscenes";
              version = "2026-06-23";

              src = inputs.mods + "/psychonauts/HD CUTSCENES - Optional 21 3 2026-06-23T23-32Z 86YpqYr0n.7z";

              nativeBuildInputs = [ pkgs.p7zip ];

              dontBuild = true;
              dontFixup = true;

              unpackPhase = ''
                runHook preUnpack
                7z x "$src" -y
                runHook postUnpack
              '';

              installPhase = ''
                runHook preInstall
                mkdir -p "$out/Cutscenes/Prerendered"
                for f in Cutscenes/Prerendered/*.bik; do
                  mv "$f" "$out/Cutscenes/Prerendered/$(basename "$f" | tr '[:upper:]' '[:lower:]')"
                done
                runHook postInstall
              '';
            };
          in
          lib.genAttrs (lib.remove "WorkResource/Cutscenes/Prerendered/DFLogo.bik" defaultCutscenesPaths)
            (path: {
              source = hdCutscenesPaths + "/Cutscenes/Prerendered/${lib.toLower (baseNameOf path)}";
            })
        );

        remove = [
          # Remove startup video
          "WorkResource/Cutscenes/Prerendered/DFLogo.bik"
        ];
      };
      # Needed for Astralathe
      dllOverrides.dsound = "n,b";
      wrappers = [
        (lib.getExe pkgs.gamescope)
        "-W"
        "3440"
        "-H"
        "1440"
        "-w"
        "6880"
        "-h"
        "2880"
        "-r"
        "60"
        "-f"
        "--force-grab-cursor"
        "--"
        "gamemoderun"
      ];
    };
  };
}
