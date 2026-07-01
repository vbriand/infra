{ den, inputs, ... }:
{
  den.aspects.gaming = {
    includes = [
      den.aspects.ludusavi
      den.aspects.steam
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
  };
}
