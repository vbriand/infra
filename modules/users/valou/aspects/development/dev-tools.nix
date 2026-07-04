{ den, lib, ... }:
{
  den.aspects.dev-tools.valou = {
    includes = lib.attrValues den.aspects.dev-tools.valou.provides;

    provides.editors = {
      includes = [
        den.aspects.emacs
        den.aspects.vscode.personal
      ];
    };

    provides.tools = {
      includes = [
        (den.aspects.better-commits { dotfile = ../../assets/better-commits.json; })
        den.aspects.git.valou.personal
      ];
    };
  };
}
