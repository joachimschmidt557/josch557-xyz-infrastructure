{ config, pkgs, ... }:

{
  systemd.tmpfiles.settings = {
    "10-var-secrets" = {
      "/var/secrets" = {
        d = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      };
    };
  };
}
