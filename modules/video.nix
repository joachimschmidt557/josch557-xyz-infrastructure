{ config, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "v.josch557.xyz" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/video";
    };
  };
}
