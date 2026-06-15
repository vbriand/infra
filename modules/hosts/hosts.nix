# Defines all hosts + users + homes.
# Then config their aspects in as many files you want.
{
  # valou user at hogwarts host.
  den.hosts.x86_64-linux.hogwarts = {
    roles = [ "gaming" ];
    users = {
      valou = {
        classes = [ ];
        roles = [ "gaming" ];
      };
    };
  };

  # Define a standalone home-manager for valou.
  den.homes.x86_64-linux."valou@hogwarts" = { };

  # Be sure to add nix-darwin input for this:
  # den.hosts.aarch64-darwin.apple.users.alice = { };

  # Other hosts can also have user valou.
  # den.hosts.x86_64-linux.south = {
  #   wsl = { }; # add nixos-wsl input for this.
  #   users.valou = { };
  #   users.orca = { };
  # };
}
