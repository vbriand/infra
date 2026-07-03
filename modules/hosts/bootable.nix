{ inputs, ... }:
{
  flake-file.inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  den.aspects.bootable = {
    nixos =
      {
        host,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.chaotic.nixosModules.default ];

        hardware.facter.reportPath = ./. + "/${host.name}/facter.json";

        boot = {
          kernelPackages = pkgs.linuxPackages_cachyos;
          loader = {
            efi.canTouchEfiVariables = true;
            systemd-boot.enable = true;
            systemd-boot.configurationLimit = 15; # Maximum number of boot entries
          };
        };

        # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
        # (the default) this is the recommended approach. When using systemd-networkd it's
        # still possible to use this option, but it's recommended to use it in conjunction
        # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
        networking.useDHCP = lib.mkDefault true;
        networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
      };
  };
}
