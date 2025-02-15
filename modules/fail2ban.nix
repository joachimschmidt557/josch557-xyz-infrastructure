{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    # FIXME find a way to include repo-external secrets that can't be included as a file
    ignoreIP = builtins.fromJSON (builtins.readFile "/home/joachim/secrets/josch557-de-infrastructure/fail2ban-ignoreips.json");
  };
}
