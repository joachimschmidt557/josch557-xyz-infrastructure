{ config, pkgs, lib, options, ... }:

let
  port = config.ports.radicale;
  mailAccounts = config.mailserver.loginAccounts;
  htpasswd = pkgs.writeText "radicale.users" (lib.concatStrings
    (lib.flip lib.mapAttrsToList mailAccounts (mail: user:
      mail + ":" + user.hashedPassword + "\n"
    ))
  );

  inherit (lib) mkOption types;
in
{
  options = {
    ports.radicale = mkOption {
      type = types.port;
      description = "Port radicale will be listening on.";
    };
  };

  config = {
    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "127.0.0.1:${toString port}" ];
        };

        auth = {
          type = "htpasswd";
          htpasswd_filename = "${htpasswd}";
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    services.nginx.virtualHosts = {
      "cal.josch557.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString port}/";
          extraConfig = ''
          proxy_set_header  X-Script-Name /;
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_pass_header Authorization;
        '';
        };
        extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Frame-Options "DENY" always;
        add_header Content-Security-Policy "frame-ancestors 'none'; default-src 'none'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self'; connect-src 'self'" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;

        add_header X-Robots-Tag "noindex, nofollow";
      '';
      };
    };

    services.restic.backups.backblaze.paths = [
      "/var/lib/radicale/collections"
    ];
  };
}
