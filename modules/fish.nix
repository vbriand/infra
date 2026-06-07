{
  den.aspects.fish = {
    nixos =
      { lib, pkgs, ... }:
      {
        programs.bash = {
          # Do not set fish as the login shell to avoid compatibility issues.
          # https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell
          interactiveShellInit = with pkgs; ''
            if [[ $(${lib.getExe' procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${lib.getExe fish} $LOGIN_OPTION
            fi
          '';
        };

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting # Disable greeting
          '';
        };
      };

    homeManager = {
      programs.fish.enable = true;
    };

    provides.valou.homeManager = {
      programs.fish = {
        shellAliases = {
          cat = "bat";
          ci = "better-commits";
          br = "better-branch";
        };
        shellAbbrs = {
          "-" = "cd -";

          ga = "git add";
          gb = "git branch";
          gbs = "git bisect";
          gbsb = "git bisect bad";
          gbsg = "git bisect good";
          gbsl = "git bisect log";
          gbsr = "git bisect reset";
          gbss = "git bisect start";
          gc = "git commit";
          gca = "git commit --amend";
          gcane = "git commit --amend --no-edit";
          gcf = "git commit --fixup";
          gco = "git checkout";
          gcp = "git cherry-pick";
          gcpa = "git cherry-pick --abort";
          gcpc = "git cherry-pick --continue";
          gd = "git diff";
          gf = "git fetch";
          gfo = "git fetch origin";
          gl = "git log";
          gp = "git push";
          gpl = "git pull";
          gr = "git rebase";
          gra = "git rebase --abort";
          grc = "git rebase --continue";
          gs = "git status";
          gsw = "git switch";
          gwa = "git worktree add";
          gwl = "git worktree list";
          gwr = "git worktree remove";

          nhs = "nh home switch -u -b backup";
          nos = "nh os switch -u";
        };
      };
    };
  };
}
