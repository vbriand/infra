{
  den.aspects.kodi = {
    homeManager =
      { pkgs, ... }:
      {
        programs.kodi = {
          enable = true;
          package = pkgs.kodi-gbm.withPackages (addOns: with addOns; [ pvr-hts ]);
        };
      };

    provides.valou.homeManager = {
      home.file = {
        ".kodi/userdata/addon_data/pvr.hts/instance-settings-1.xml".source = ../conf/kodi-pvr.hts.xml;
      };
    };
  };
}
