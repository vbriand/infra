{
  den.aspects.audio = {
    nixos = {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      # Enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand.
      # This is especially useful for PipeWire to avoid crackling noises on high system load.
      security.rtkit.enable = true;
    };

    provides.effects = {
      homeManager = {
        services.easyeffects.enable = true;
      };
    };
  };
}
