{ config, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "v.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/video";
      extraConfig = ''
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Frame-Options "DENY" always;
        add_header Content-Security-Policy "frame-ancestors 'none'" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;

        add_header X-Robots-Tag "noindex, nofollow";
      '';
    };
  };
}
