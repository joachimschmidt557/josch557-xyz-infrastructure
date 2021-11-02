{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    ignoreIP = builtins.fromJSON (builtins.readFile ../secrets/fail2ban-ignoreips.json);
  };
}
