{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./searchlight/hardware-configuration.nix
      ../modules/nix-configuration.nix
      ../modules/fail2ban.nix
      ../modules/ssh.nix
      ../modules/secrets.nix

      ../modules/laplace.nix
      ../modules/video.nix
      ../modules/website.nix
      ../modules/timew-sync-server.nix
      ../modules/ntfy.nix
      ../modules/forgejo.nix
      ../modules/mailserver.nix
      ../modules/radicale.nix
      ../modules/playlist-thing.nix
      ../modules/playlist-thing-api.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "searchlight";
  networking.nameservers = [ "1.1.1.1" ];

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

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

  services.openssh.enable = true;

  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      server_names_hash_bucket_size 64;
    '';
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."searchlight.josch557.de" = {
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
    timew-sync-server = 8710;
    forgejo = 8750;
    radicale = 5232;
    playlist-thing = 8760;
  };

  services.restic.backups.backblaze = {
    repository = "b2:searchlight-01";
    environmentFile = "/var/secrets/restic_env";
    passwordFile = "/var/secrets/restic_password";
    initialize = true;
  };

  system.stateVersion = "24.11";

}
