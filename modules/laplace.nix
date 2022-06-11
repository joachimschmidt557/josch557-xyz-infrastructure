{ config, pkgs, ... }:

let
  listenAddress = "127.0.0.1";
  port = 8700;
  laplace = pkgs.callPackage
    ({ buildGoModule, fetchFromGitHub }:
      buildGoModule rec {
        pname = "laplace";
        version = "0.0.1";

        src = fetchFromGitHub {
          owner = "adamyordan";
          repo = pname;
          rev = "6d877051e28fd25f9ab85ed2cfbe31d76d857be3";
          sha256 = "0l7w7my64yi2pig8sdxgk8049ah3n1mb2wfw858ys3gk42xqa5xh";
        };

        vendorSha256 = "022bil46fyjsd18diw0rnab987sp1ialb48rj18ksj75ghjqkr62";

        postInstall = ''
          rm files/server.crt files/server.key
          mkdir -p $out/share/laplace
          mv files $out/share/laplace/
        '';
      }
    )
    { };
in
{
  users.users.laplace = {
    description = "laplace";
    group = "laplace";
    isSystemUser = true;
  };

  users.groups.laplace = { };

  systemd.services.laplace = {
    description = "laplace";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "laplace";
      Group = "laplace";
      WorkingDirectory = "${laplace}/share/laplace";
      ExecStart = "${laplace}/bin/laplace -addr ${listenAddress}:${toString port} -tls=false";
      Restart = "always";

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
    "laplace.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${listenAddress}:${toString port}";
        proxyWebsockets = true;
      };
    };
  };
}
