{ den, lib, ... }:
{
  den.aspects.dev-tools.valou = {
    includes = lib.attrValues den.aspects.dev-tools.valou.provides;

    provides.editors = {
      includes = with den.aspects.applications.development.editors; [
        emacs
        vscode.personal
      ];
    };

    provides.tools = {
      includes = with den.aspects.applications.development.vcs; [
        (better-commits {
          dotfile = ../../assets/better-commits.json;
        })
        git.valou.personal
      ];
    };
  };
}
