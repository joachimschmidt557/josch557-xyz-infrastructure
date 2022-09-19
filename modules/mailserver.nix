{ config, pkgs, ... }:

{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/f535d8123c4761b2ed8138f3d202ea710a334a1d/nixos-mailserver-f535d8123c4761b2ed8138f3d202ea710a334a1d.tar.gz";
      sha256 = "0csx2i8p7gbis0n5aqpm57z5f9cd8n9yabq04bg1h4mkfcf7mpl6";
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
