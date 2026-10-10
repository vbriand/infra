{
  den.aspects.applications.security.gpg = {
    nixos = {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
