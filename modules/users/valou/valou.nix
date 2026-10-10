{
  den,
  inputs,
  lib,
  ...
}:
{
  den.aspects.valou = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.aspects.applications.shells.fish
      den.aspects.applications.gaming
      den.aspects.applications.terminals.ghostty
      den.aspects.nh
      den.aspects.applications.media.kodi
      den.aspects.secrets
      den.aspects.applications.networking.syncthing
      den.aspects.applications.browsers.zen-browser
    ];

    user =
      { config, ... }:
      {
        hashedPasswordFile = config.sops.secrets."passwords/valou".path;
        extraGroups = [
          "gamemode" # TODO: find how to make it dependent on programs.gamemode.enable
          "i2c" # Same for hardware.i2c.enable
        ];
      };

    homeManager =
      { home, pkgs, ... }:
      {
        home.packages = with pkgs; [
          nixfmt

          # # It is sometimes useful to fine-tune packages, for example, by applying
          # # overrides. You can do that directly here, just don't forget the
          # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
          # # fonts?
          # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

          # # You can also create simple shell scripts directly inside your
          # # configuration. For example, this adds a command 'my-hello' to your
          # # environment:
          # (pkgs.writeShellScriptBin "my-hello" ''
          #   echo "Hello, ${config.home.username}!"
          # '')
        ];
      };

    provides.hogwarts = {
      nixos = {
        programs = {
          firefox.enable = true;
          thunderbird.enable = true;
        };
      };
      includes = with den.aspects; [
        hardware.audio.effects
        dev-tools.valou
        applications.gaming.ludusavi.daily-backup
        desktops.plasma
      ];
    };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
