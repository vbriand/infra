{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium.url = "git+https://github.com/SteamClientHomebrew/Millennium?ref=legacy";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/vbriand/nix-secrets?ref=master&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      disko,
      home-manager,
      nixpkgs,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        hogwarts = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs system; };
          modules = [
            ./configuration.nix
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            {
              disko.devices = {
                disk = {
                  main = {
                    # When using disko-install, we will overwrite this value from the commandline
                    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_2TB_S7U7NU0Y417341K";
                    type = "disk";
                    content = {
                      type = "gpt";
                      partitions = {
                        ESP = {
                          priority = 1;
                          size = "1G";
                          type = "EF00";
                          content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                          };
                        };
                        root = {
                          size = "100%";
                          content = {
                            type = "btrfs";
                            extraArgs = [
                              "-f"
                              "-L"
                              "NixOS"
                            ];
                            subvolumes = {
                              "/rootfs" = {
                                mountpoint = "/";
                              };
                              "/home" = {
                                mountOptions = [ "compress=zstd" ];
                                mountpoint = "/home";
                              };
                              # "/home/valou" = { };
                              "/nix" = {
                                mountOptions = [
                                  "compress=zstd"
                                  "noatime"
                                ];
                                mountpoint = "/nix";
                              };
                              "/log" = {
                                mountOptions = [ "compress=zstd" ];
                                mountpoint = "/var/log";
                              };
                            };

                            mountpoint = "/partition-root";
                          };
                        };
                      };
                    };
                  };
                };
              };
            }
          ];
        };
      };
      homeConfigurations = {
        valou = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ];
        };
      };
    };
}
