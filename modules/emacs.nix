{
  den.aspects.emacs = {
    nixos = { pkgs, ... }: {
      environment = {
        systemPackages = [ pkgs.emacs-nox ];
      };
    };

    provides.valou.homeManager = { pkgs, ... }: {
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
