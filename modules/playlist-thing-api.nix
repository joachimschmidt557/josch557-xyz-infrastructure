{ lib, config, pkgs, options, ... }:

{
  config = {
    services.nginx.virtualHosts = {
      "api.playlist-thing.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          return = "404";
        };
      };

      "localapi.playlist-thing.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          return = "404";
        };
      };
    };
  };
}
