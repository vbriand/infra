{ den, lib, ... }:
{
  den.aspects.dev-tools.valou = {
    editors = {
      includes = with den.aspects.applications.development.editors; [
        emacs
        vscode.personal
      ];
    };

    tools = {
      includes = with den.aspects.applications.development.vcs; [
        (better-commits {
          dotfile = ../../assets/better-commits.json;
        })
        git.valou.personal
      ];
    };
  };
}
