{
  den.aspects.ssh = {
    homeManager = {
      programs.ssh.enable = true;
    };

    provides.valou.homeManager = {
      programs.ssh = {
        enableDefaultConfig = false;
        matchBlocks = {
          "github" = {
            host = "github.com";
            identitiesOnly = true;
            identityFile = [
              "~/.ssh/id_ed25519"
            ];
          };
        };
      };
    };
  };
}
