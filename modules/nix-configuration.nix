{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

    gc = {
      automatic = true;
      dates = "daily";
      options = "-d";
    };
  };
}
