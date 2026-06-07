{
  den.aspects.nh = {
    nixos = {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 15";
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
