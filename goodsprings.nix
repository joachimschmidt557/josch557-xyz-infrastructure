{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/nix-configuration.nix
      ./modules/fail2ban.nix
      ./modules/laplace.nix
      ./modules/timew-sync-server.nix
      ./modules/mailserver.nix
      ./modules/hydra.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "goodsprings";

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

    virtualHosts."goodsprings.josch557.xyz" = {
      locations."/" = {
        return = "404";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  system.stateVersion = "21.05";
}
