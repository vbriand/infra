{ inputs, ... }:
{
  flake-file.inputs = {
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  den.aspects.plasma = {
    nixos =
      { pkgs, ... }:
      {
        services = {
          desktopManager.plasma6.enable = true;
          displayManager = {
            defaultSession = "plasma";
            sddm = {
              enable = true;
              wayland.enable = true;
            };
          };
        };

        environment = {
          plasma6.excludePackages = with pkgs.kdePackages; [
            plasma-browser-integration
            kdepim-runtime
            konsole
          ];
          systemPackages = with pkgs.kdePackages; [
            fcitx5-configtool
            kcalc # Calculator
            kcharselect # Tool to select and copy special characters from all installed fonts
            sddm-kcm # Configuration module for SDDM
            partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
            # kdotool # Enable automatic page switching for streamcontroller
          ];
        };

        programs.kdeconnect.enable = true;
      };

    homeManager = { osConfig, pkgs, ... }: {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

      programs.plasma = {
        enable = true;
        overrideConfig = true;
        workspace = {
          colorScheme = "BreezeDark";
          wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/SafeLanding/contents/images/5120x2880.jpg";
        };
        panels = [
          {
            location = "top";
            height = 30;
            hiding = "autohide";
            screen = 0;
            widgets = [
              "org.kde.plasma.kickoff"
              "org.kde.plasma.pager"
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.showdesktop"
            ];
          }
          {
            floating = true;
            lengthMode = "fit";
            location = "bottom";
            height = 52;
            hiding = "autohide";
            screen = 0;
            widgets = [ "org.kde.plasma.icontasks" ];
          }
        ];
      };

      xdg.configFile."kdeconnect/config".text = ''
        [General]
        disabled_providers=AsyncLinkProvider
        keyAlgorithm=EC
        name=${osConfig.networking.hostName}
      '';
    };
  };
}
