{ config, pkgs, ... }:

{
  nix = {
    binaryCaches = [
      "https://zig-nightly.cachix.org"
    ];
    binaryCachePublicKeys = [
      "zig-nightly.cachix.org-1:OnBNrwrXNoCtCzjuMEfruWSaZEixGGSvFhc9OBtx1wg="
    ];
  };
}
