{ config, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "josch557.de" = {
      forceSSL = true;
      enableACME = true;
      globalRedirect = "www.josch557.de";
    };

    "www.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "404";
      };
    };
  };
}
