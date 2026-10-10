{
  den.aspects.applications.development.vcs.better-commits = { dotfile, ... }: {
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
