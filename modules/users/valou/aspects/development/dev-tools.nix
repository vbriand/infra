{ den, lib, ... }:
{
  den.aspects.dev-tools.valou = {
    editors = {
      includes = with den.aspects.applications.development.editors; [
        emacs
        vscode
      ];
    };

    tools = {
      includes = with den.aspects.applications.development.vcs; [
        (better-commits {
          dotfile = ../../assets/better-commits.json;
        })
        git
      ];
    };
  };
}
