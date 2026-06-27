{
  inputs,
  ...
}:
let
  secretsPath = builtins.toString inputs.nix-secrets;
in
{
  flake-file.inputs = {
    nix-secrets = {
      url = "git+ssh://git@github.com/vbriand/nix-secrets?ref=master&shallow=1";
      flake = false;
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.secrets = {
    nixos = { config, ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = "${secretsPath}/secrets.yaml";
        validateSopsFiles = false;
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
        secrets = {
          "passwords/valou" = {
            neededForUsers = true;
          };
        };
      };

      services.openssh = {
        enable = true;
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
    };

    provides.valou.homeManager =
      { home, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        sops =
          let
            homeDirectory = "/home/${home.name}";
          in
          {
            age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
            defaultSopsFile = "${secretsPath}/secrets.yaml";
            validateSopsFiles = false;
            secrets = {
              "keys/ssh/${home.name}" = {
                path = "${homeDirectory}/.ssh/id_ed25519";
              };
              "keys/syncthing/hogwarts" = {
                # No output path needed as services.syncthing.key will copy the file itself
              };
              "keys/api/sgdb" = { };
              "emails/mozilla" = { };
              "emails/mazarine" = { };
            };
          };
      };
  };
}
