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
      environmentFiles = [
        "/var/secrets/playlist-thing_env"
      ];
    };

    services.nginx.virtualHosts = {
      "playlist-thing.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
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
