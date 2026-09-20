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
        };
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
