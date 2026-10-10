{ den, inputs, ... }:
{
  den.aspects.applications.gaming = {
    includes = [
      den.aspects.applications.gaming.steam
    ];

    nixos = { pkgs, ... }: {
      boot.kernelModules = [ "ntsync" ];

      environment = {
        systemPackages = with pkgs; [
          heroic
          protonplus
        ];
      };

      services = {
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
        };
      };
    };

    provides.communication = {
      nixos = { pkgs, ... }: {
        environment = {
          systemPackages = with pkgs; [
            discord
            teamspeak6-client
          ];
        };
      };
    };
  };
}
