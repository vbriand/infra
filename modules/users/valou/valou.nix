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
      den.aspects.audio.effects
      den.aspects.better-commits
      den.aspects.emacs
      den.aspects.fish
      den.aspects.gaming
      den.aspects.ghostty
      den.aspects.git
      den.aspects.nh
      den.aspects.kodi
      den.aspects.plasma
      den.aspects.secrets
      den.aspects.syncthing
      den.aspects.vscode
      den.aspects.zen-browser
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

    provides.hogwarts.nixos = {
      programs = {
        firefox.enable = true;
        thunderbird.enable = true;
      };
    };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
