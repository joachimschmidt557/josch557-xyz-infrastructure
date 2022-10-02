{ config, pkgs, ... }:

let
  port = 8720;
in
{
  services.gotify = {
    enable = true;
    port = port;
  };

  services.nginx.virtualHosts = {
    "noti.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          # https://gotify.net/docs/nginx
          # These sets the timeout so that the websocket can stay alive
          proxy_connect_timeout   1m;
          proxy_send_timeout      1m;
          proxy_read_timeout      1m;
        '';
      };
    };
  };
}
