{ den, ... }:
{
  den.aspects.git.base = {
    homeManager = {
      programs.git.enable = true;
    };
  };

  den.aspects.git.valou = {
    personal = {
      includes = [ den.aspects.git.base ];

      homeManager =
        { config, ... }:
        {
          programs.git = {
            signing = {
              key = "2708255FFF876F95";
              signByDefault = true;
            };
            settings = {
              user = {
                name = "Valentin Briand";
                email = "678530+vbriand@users.noreply.github.com";
              };
              alias = {
                # https://discourse.nixos.org/t/how-to-avoid-new-line-in-nix-variable/49241/4
                # Remove local branches that have been merged to the main branch
                bclean = "!f() { git branch --merged \${1 - main} | grep -v \" \${1 - main}$\" | xargs -r git branch -d; }; f";
                br = "branch";
                ci = "commit";
                co = "checkout";
                st = "status";
                # Stash only untracked files
                su = "!f() { git stash; git stash -u; git stash pop stash@{1}; }; f";
                # Stash changes not staged for commit and untracked files
                snsu = "!f() { git stash push --staged; git stash -u; git stash pop stash@{1}; }; f";
                # Stash changes not staged for commit
                sns = "!f() { git stash push --staged; git stash; git stash pop stash@{1}; }; f";
                sw = "switch";
                wta = "worktree add";
                wtl = "worktree list";
                # Remove a worktree and its branch
                wtr = "!f() { BRANCH=$(git -C \"$1\" branch --show-current 2>/dev/null); git worktree remove \"$1\" && git branch -d \"$BRANCH\"; }; f";
              };
              core = {
                editor = "emacs";
              };
              init.defaultBranch = "main";
              pull.rebase = true;
              push.autoSetupRemote = true; # https://stackoverflow.com/a/17096880/10927329
              rebase.autoSquash = true;
              rebase.autoStash = true;
            };
            # https://discourse.nixos.org/t/home-manager-what-is-the-best-way-to-use-a-long-global-gitignore-file/24986
            ignores = import ./_gitignore_global.nix;
          };
        };
    };

    work = {
      includes = [ den.aspects.git.valou.personal ];

      homeManager =
        { config, ... }:
        {
          sops.templates."git-mazarine".content = ''
            [user]
              email = ${config.sops.placeholder."emails/mazarine"}
          '';

          includes = [
            {
              path = config.sops.templates."git-mazarine".path;
              condition = "hasconfig:remote.*.url:git@gitlab.mzrn.net:*/**";
            }
          ];
        };
    };
  };
}
