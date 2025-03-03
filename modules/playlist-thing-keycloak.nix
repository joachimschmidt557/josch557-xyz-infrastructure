{ config, pkgs, lib, options, ... }:

let
  port = config.ports.keycloak;
  docker = pkgs.docker;
  docker-compose = pkgs.docker-compose;
  compose-file-dir = pkgs.writeTextDir "compose.yml" ''
    name: keycloak

    services:
      db:
        image: postgres:17-alpine
        volumes:
          - /var/lib/keycloak/db:/var/lib/postgresql/data
        environment:
          - POSTGRES_USER=playlist-thing
          - POSTGRES_DB=playlist-thing
        env_file: /var/secrets/keycloak_env

      keycloak:
        image: quay.io/keycloak/keycloak:26.1.3
        command: start
        mem_limit: 1g
        ports:
          - 127.0.0.1:${toString port}:8080
        depends_on:
          - db
        environment:
          - KC_DB=postgres
          - KC_DB_URL=jdbc:postgresql://db/playlist-thing
          - KC_DB_USERNAME=playlist-thing
          - KC_HOSTNAME=https://accounts.playlist-thing.com
          - KC_HTTP_ENABLED=true
          - KC_PROXY_HEADERS=xforwarded
        env_file: /var/secrets/keycloak_env
  '';

  inherit (lib) mkOption types;
in
{
  options = {
    ports.keycloak = mkOption {
      type = types.port;
      description = "Port keycloak will be listening on.";
    };
  };

  config = {
    virtualisation.docker.enable = true;

    systemd.services.docker-compose-keycloak = {
      description = "docker-compose setup for keycloak";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        docker
        docker-compose
      ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = compose-file-dir;
        ExecStart = "${docker}/bin/docker compose up --detach";
        ExecStop = "${docker}/bin/docker compose down";
        RemainAfterExit = true;
      };
    };

    systemd.tmpfiles.settings = {
      "10-keycloak-db" = {
        "/var/lib/keycloak/db" = {
          d = {
            user = "root";
            group = "root";
            mode = "0700";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "accounts.playlist-thing.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString port}/";
        };
      };
    };

    services.restic.backups.backblaze.paths = [
      "/var/lib/keycloak"
    ];
  };
}
