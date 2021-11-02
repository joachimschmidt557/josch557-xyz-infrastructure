{ config, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "v.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/video";
    };
  };
}
