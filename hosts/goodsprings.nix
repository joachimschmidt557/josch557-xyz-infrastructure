{ config, pkgs, ... }:

{
  imports =
    [
      ./goodsprings/hardware-configuration.nix
      ../modules/nix-configuration.nix
      ../modules/fail2ban.nix
      ../modules/ssh.nix

      ../modules/laplace.nix
      ../modules/timew-sync-server.nix
      ../modules/mailserver.nix
      ../modules/radicale.nix
      ../modules/video.nix
      ../modules/ntfy.nix
      ../modules/website.nix
      ../modules/forgejo.nix
      ../modules/playlist-thing.nix
      ../modules/playlist-thing-api.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "goodsprings";
  networking.nameservers = [ "1.1.1.1" ];

  time.timeZone = "Europe/Berlin";

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "joachim.schmidt557@outlook.com";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  deployment.targetPort = 22;

  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      server_names_hash_bucket_size 64;
    '';
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."goodsprings.josch557.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        return = "404";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  ports = {
    laplace = 8700;
    ntfy = 8730;
    radicale = 5232;
    timew-sync-server = 8710;
    forgejo = 8750;
    playlist-thing = 8760;
  };

  services.restic.backups.backblaze = {
    repository = "b2:goodsprings-01";
    environmentFile = "/var/secrets/restic_env";
    passwordFile = "/var/secrets/restic_password";
  };

  system.stateVersion = "21.05";
}
