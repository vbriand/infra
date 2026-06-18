{
  den.aspects.nh = {
    nixos = {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 15 --optimize";
          dates = "Sun, 22:00";
        };
      };
    };

    provides.valou.homeManager =
      { home, ... }:
      {
        programs.nh = {
          enable = true;
          flake = "/home/${home.name}/Workspace/infra";
        };
      };
  };
}
