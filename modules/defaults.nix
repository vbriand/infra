{
  inputs,
  lib,
  den,
  ...
}:
{
  flake-file.inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  den.default.nixos.system.stateVersion = "25.05"; # Did you read the comment?

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  den.default.homeManager.home.stateVersion = "25.05"; # Please read the comment before changing.

  den.default.homeManager.nixpkgs.config.allowUnfree = true;
  den.default.nixos.nixpkgs.config.allowUnfree = true;
  den.default.nixos.nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.default ];

  # Enable HM by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.includes = [ den.batteries.hostname ];

  den.default.nixos.networking.networkmanager.enable = true;
  den.default.nixos.time.timeZone = "Europe/Paris";

  den.default.nixos.i18n.defaultLocale = "en_US.UTF-8";
  den.default.nixos.i18n.extraLocaleSettings = {
    LC_CTYPE = "fr_FR.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
    LC_COLLATE = "fr_FR.UTF-8";
  };

  den.default.nixos.documentation.doc.enable = false;

  den.default.nixos.nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
