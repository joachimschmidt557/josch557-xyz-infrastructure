{ config, pkgs, ... }:

{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/5675b122a947b40e551438df6a623efad19fd2e7/nixos-mailserver-5675b122a947b40e551438df6a623efad19fd2e7.tar.gz";
      sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "goodsprings.josch557.de";
    domains = [ "josch557.de" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = builtins.fromJSON (builtins.readFile ../secrets/mailserver-accounts.json);

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # TODO I had some issues with knot
    localDnsResolver = false;
  };

  services.restic.backups.backblaze.paths = [
    "/var/vmail"
  ];
}
