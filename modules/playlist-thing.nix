{ lib, config, pkgs, options, ... }:

let
  port = config.ports.playlist-thing;

  inherit (lib) mkOption types;
in
{
  options = {
    ports.playlist-thing = mkOption {
      type = types.port;
      description = "Port playlist-thing will be listening on.";
    };
  };

  config = {
    virtualisation.oci-containers.containers.playlist-thing = {
      image = "ghcr.io/playlist-thing/playlist-thing:main";
      ports = [ "127.0.0.1:${toString port}:3000" ];
      environment = {
        ADDRESS_HEADER = "X-Forwarded-For";
        PROTOCOL_HEADER = "X-Forwarded-Proto";
        HOST_HEADER = "X-Forwarded-Host";
      };
    };

    services.nginx.virtualHosts = {
      "playlist-thing.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
          '';
        };
        extraConfig = ''
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
          add_header X-Frame-Options "DENY" always;
          add_header Content-Security-Policy "frame-ancestors 'none'" always;
          add_header X-XSS-Protection "1; mode=block" always;
          add_header X-Content-Type-Options "nosniff" always;
        '';
      };
    };
  };
}
