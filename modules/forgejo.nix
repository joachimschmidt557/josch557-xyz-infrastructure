{ config, pkgs, lib, options, ... }:

let
  port = config.ports.forgejo;

  inherit (lib) mkOption types;
in {
  options = {
    ports.forgejo = mkOption {
      type = types.port;
      description = "Port forgejo will be listening on.";
    };
  };

  config = {
    # add forgejo (as gitea) to $PATH for administration using CLI
    users.users.forgejo.packages = [
      config.services.forgejo.package
    ];

    services.forgejo = {
      enable = true;

      settings = {
        server = {
          HTTP_PORT = port;
          DOMAIN = "git.josch557.de";
          ROOT_URL = "https://git.josch557.de";
          SSH_PORT = 22;
        };

        session = {
          COOKIE_SECURE = true;
        };

        service = {
          DISABLE_REGISTRATION = true;
        };
      };
    };

    services.nginx.virtualHosts = {
      "git.josch557.de" = {
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

        add_header X-Robots-Tag "noindex, nofollow" always;
      '';
      };
    };

    services.restic.backups.backblaze.paths = [
      config.services.forgejo.stateDir
    ];
  };
}
