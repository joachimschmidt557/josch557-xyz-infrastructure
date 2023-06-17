{ lib, config, pkgs, ... }:

let
  port = 8730;
  user = "ntfy-sh";
  group = "ntfy-sh";
in
{
  services.ntfy-sh = {
    enable = true;
    user = user;
    group = group;
    settings = {
      base-url = "https://ntfy.josch557.de";
      listen-http = "127.0.0.1:${toString port}";
      behind-proxy = true;

      cache-file = "/var/cache/ntfy/cache.db";
      attachment-cache-dir = "/var/cache/ntfy/attachments";
      attachment-total-size-limit = "512M";

      auth-file = "/var/lib/ntfy/user.db";
      auth-default-access = "deny-all";

      # log-level = "TRACE";
      web-root = "disable";
    };
  };

  # /var/lib/ntfy
  systemd.services.ntfy-sh.serviceConfig.StateDirectory = lib.mkForce "ntfy";

  # /var/cache/ntfy
  systemd.services.ntfy-sh.serviceConfig.CacheDirectory = "ntfy";

  services.nginx.virtualHosts = {
    "ntfy.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}
