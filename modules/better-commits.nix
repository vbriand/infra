{
  den.aspects.better-commits = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          better-commits
        ];
      };

    provides.valou.homeManager = {
      home.file = {
        ".better-commits.json".source = ../conf/better-commits.json;
      };
    };
  };
}
