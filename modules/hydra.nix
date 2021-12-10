{ config, pkgs, ... }:

let
  port = 8800;
in
{
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.josch557.de";
    useSubstitutes = true;
    port = port;
    buildMachinesFiles = [ ];
    notificationSender = "hydra@josch557.de";
    minimumDiskFree = 5;
  };

  services.nginx.virtualHosts = {
    "hydra.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  };
}
