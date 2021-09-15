{ config, pkgs, ... }:

let
  port = 8710;
  package = pkgs.timew-sync-server;
in {
  users.users.timew-sync-server = {
    description = "timewarrior synchronization server";
    group = "timew-sync-server";
    isSystemUser = true;
  };

  users.groups.timew-sync-server = {};

  systemd.services.timew-sync-server = {
    description = "timewarrior synchronization server";
    after = [ "network.target "];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "timew-sync-server";
      Group = "timew-sync-server";
      WorkingDirectory = "/var/lib/timew-sync-server";
      ExecStart = "${package}/bin/timew-sync-server start -port ${toString port}";
      Restart = "always";
      StateDirectory = "timew-sync-server";
      StateDirectoryMode = "0700";

      # Capabilities
      CapabilityBoundingSet = "";

      # Security
      NoNewPrivileges = true;

      # Sandboxing
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      PrivateMounts = true;
    };
  };

  services.nginx.virtualHosts = {
    "timewsync.josch557.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };
    };
  };

  services.duplicity.include = [
    "/var/lib/timew-sync-server"
  ];
}
