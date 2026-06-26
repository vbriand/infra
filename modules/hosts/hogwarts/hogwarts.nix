{ den, inputs, ... }:
{
  flake-file.inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  # host aspect
  den.aspects.hogwarts = {
    includes = [
      den.aspects.audio
      den.aspects.emacs
      den.aspects.filesystem
      den.aspects.fish
      den.aspects.flatpak
      den.aspects.gaming
      den.aspects.ghostty
      den.aspects.gpg
      den.aspects.nh
      den.aspects.plasma
      den.aspects.secrets
      den.aspects.ssh
      den.aspects.syncthing
    ];

    # host NixOS configuration
    nixos =
      {
        config,
        lib,
        modulesPath,
        pkgs,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
          inputs.chaotic.nixosModules.default
        ];

        boot.loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = 15; # Maximum number of boot entries
        };
        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.kernelPackages = pkgs.linuxPackages_cachyos;
        boot.initrd.kernelModules = [ ];
        boot.extraModulePackages = [ ];
        boot.kernelParams = [
          "amdgpu.dcdebugmask=0x10"
          # Enable overclocking https://github.com/ilya-zlobintsev/LACT/wiki/Overclocking-(AMD)
          "amdgpu.ppfeaturemask=0xffffffff"
        ];

        # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
        # (the default) this is the recommended approach. When using systemd-networkd it's
        # still possible to use this option, but it's recommended to use it in conjunction
        # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
        networking.useDHCP = lib.mkDefault true;

        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        hardware.xone.enable = true;
        hardware.i2c.enable = true; # Allow changing the monitor's brightness

        environment = {
          systemPackages = with pkgs; [
            anytype
            bat
            (bottles.override { removeWarningPopup = true; })
            caprine
            discord
            fishPlugins.done
            fishPlugins.tide
            git
            hardinfo2 # System information and benchmarks for Linux systems
            lact # GPU metrics and overclocking
            obsidian
            piper # Mouse configuration GUI
            snapper
            snapper-gui
            tealdeer
            teamspeak6-client
            wayland-utils # Wayland utilities
            wget
            wl-clipboard # Command-line copy/paste utilities for Wayland
          ];
          variables = {
            AMD_VULKAN_ICD = "RADV"; # Enforce RADV Vulkan implementation https://docs.mesa3d.org/drivers/radv.html
            MESA_SHADER_CACHE_MAX_SIZE = "12G";
          };
        };

        networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            # Disable setting the GTK_IM_MODULE & QT_IM_MODULE environment variables to
            # avoid getting a warning and a potential blinking issue on KDE Plasma.
            # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma
            waylandFrontend = true;
            settings = {
              inputMethod = {
                GroupOrder."0" = "Default";
                "Groups/0" = {
                  Name = "Default";
                  "Default Layout" = "us-intl";
                  DefaultIM = "keyboard-fr-ergol";
                };
                "Groups/0/Items/0".Name = "keyboard-us-intl";
                "Groups/0/Items/1".Name = "keyboard-fr-ergol";
              };
              globalOptions = {
                Behavior = {
                  ActiveByDefault = false;
                };
                Hotkey = {
                  EnumerateWithTriggerKeys = true;
                };
                "Hotkey/TriggerKeys"."0" = "Control+Alt+space";
              };
            };
          };
        };

        services = {
          ratbagd.enable = true;
          xserver = {
            enable = true; # Enable the X11 windowing system.
            excludePackages = [ pkgs.xterm ];
          };
        };

        systemd.services = {
          lact = {
            description = "AMDGPU Control Daemon";
            after = [ "multi-user.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${lib.getExe pkgs.lact} daemon";
            };
            enable = true;
          };
        };

        # https://nix-community.github.io/home-manager/index.xhtml#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
        programs.dconf.enable = true;
      };

    # Host provides default home environment for its users
    # (appears to be broken at the moment)
    /*
      provides.to-users = { user, ... }: {
        hardware.i2c.enable = true; # Allow changing the monitor's brightness
        users.users.${user.name}.extraGroups = [ "i2c" ];
        homeManager =
          { pkgs, ... }:
          {
            home.packages = [ pkgs.vim ];
          };
      };
    */
  };
}
