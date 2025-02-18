{ config, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "accounts.playlist-thing.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "404";
      };
    };
  };
}
