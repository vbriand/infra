{ inputs, ... }:
{
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.filesystem = {
    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices.disk.main = {
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

      fileSystems."/mnt/games" = {
        device = "/dev/disk/by-label/Games";
        fsType = "btrfs";
        options = [ "compress=zstd" ];
      };
    };
  };
}
