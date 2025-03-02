{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.11";
  inputs.arion.url = "github:hercules-ci/arion/main";

  outputs = { self, nixpkgs, simple-nixos-mailserver, arion }: {

    colmena = {

      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      searchlight =
        { config, pkgs, ... }:
        {
          deployment.targetHost = "searchlight.josch557.de";

          imports = [
            ./hosts/searchlight.nix
            simple-nixos-mailserver.nixosModule
          ];
        };

      novac =
        { config, pkgs, ... }:
        {
          deployment.targetHost = "novac.josch557.de";

          imports = [
            ./hosts/novac.nix
          ];
        };

    };

  };

}
