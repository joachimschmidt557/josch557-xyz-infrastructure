{ config, pkgs, ... }:

let
  port = 8800;
in {
  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.josch557.xyz";
    useSubstitutes = true;
    port = port;
    buildMachinesFiles = [];
    notificationSender = "hydra@josch557.xyz";
    minimumDiskFree = 5;
  };

  services.nginx.virtualHosts = {
    "hydra.josch557.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  };
}
