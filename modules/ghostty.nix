{
  flake-file.inputs = {
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.ghostty = {
    homeManager = {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true; # TODO: enable only when fish is used.
      };
    };

    provides.valou.homeManager = {
      programs.ghostty = {
        settings = {
          theme = "Synthwave";
        };
      };
    };
  };
}
