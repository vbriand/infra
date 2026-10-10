{
  den.aspects.applications.development.editors.emacs = {
    homeManager = { pkgs, ... }: {
      programs.emacs = {
        enable = true;
        extraConfig = ''
          (setq column-number-mode t)
        '';
        package = pkgs.emacs-nox;
      };
    };
  };
}
