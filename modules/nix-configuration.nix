{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "daily";
      options = "-d";
    };
  };
}
