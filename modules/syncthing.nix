{
  den.aspects.syncthing = {
    nixos = {
      networking.firewall.allowedTCPPorts = [
        22000
      ];
      networking.firewall.allowedUDPPorts = [
        22000
      ];
    };

    homeManager = {
      services.syncthing.enable = true;
    };

    provides.valou.homeManager =
      { config, ... }:
      {
        services.syncthing = {
          key = config.sops.secrets."keys/syncthing/hogwarts".path;
          cert = "./cert.pem";
          tray.enable = true;
          settings = {
            devices = {
              Gringotts = {
                id = "ANJBTRA-BXCRHCH-HDMWTWZ-3F2BRR3-SS7R4TW-KNM3L7F-WTTDOTP-TCASSAG";
              };
            };
            folders = {
              "Steam grid" = {
                devices = [ "Gringotts" ];
                id = "cjnuh-vcntm";
                label = "Steam grid images";
                path = "~/.steam/steam/userdata/11938770/config/grid";
              };
            };
            options = {
              # Disable global discovery to prevent making the IP address public
              # https://docs.syncthing.net/users/faq.html#should-i-keep-my-device-ids-secret
              globalAnnounceEnabled = false;
              relaysEnabled = false;
              urAccepted = -1; # Refuse to submit anonymous usage data
            };
          };
          overrideDevices = true;
          overrideFolders = true;
        };
      };
  };
}
