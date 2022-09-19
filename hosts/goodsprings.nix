{ config, pkgs, ... }:

{
  imports =
    [
      ./goodsprings/hardware-configuration.nix
      ../modules/nix-configuration.nix
      ../modules/fail2ban.nix
      ../modules/laplace.nix
      ../modules/timew-sync-server.nix
      ../modules/mailserver.nix
      ../modules/radicale.nix
      ../modules/video.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
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
    email = "joachim.schmidt557@outlook.com";
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

    virtualHosts."goodsprings.josch557.de" = {
      locations."/" = {
        return = "404";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.restic.backups.backblaze = {
    repository = "b2:goodsprings-01";
    environmentFile = "/var/secrets/restic_env";
    passwordFile = "/var/secrets/restic_password";
  };

  system.stateVersion = "21.05";
}
