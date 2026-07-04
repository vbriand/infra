{
  den.aspects.better-commits = { dotfile, ... }: {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          better-commits
        ];

        home.file = {
          ".better-commits.json".source = dotfile;
        };
      };
  };
}
