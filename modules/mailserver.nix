{ config, pkgs, ... }:

{
  mailserver = {
    enable = true;
    fqdn = "searchlight.josch557.de";
    domains = [ "josch557.de" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    # FIXME find a way to include repo-external secrets that can't be included as a file
    loginAccounts = builtins.fromJSON (builtins.readFile "/home/joachim/secrets/josch557-de-infrastructure/mailserver-accounts.json");

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";

    # TODO I had some issues with knot
    localDnsResolver = false;
  };

  services.restic.backups.backblaze.paths = [
    "/var/vmail"
  ];

  services.fail2ban.jails.dovecot = {
    settings = {
      filter = "dovecot";
    };
  };

  services.fail2ban.jails.postfix = {
    settings = {
      filter = "postfix[mode=aggressive]";
    };
  };
}
