{
  den.aspects.hardware.monitor = { user, ... }: {
    nixos = { pkgs, ... }: {
      hardware.i2c.enable = true; # Allow changing the monitor's brightness

      users.users.${user.userName}.extraGroups = [ "i2c" ];
    };
  };
}
