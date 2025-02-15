{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.11";

  outputs = { self, nixpkgs, simple-nixos-mailserver }: {

    colmena = {

      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      goodsprings =
        { config, pkgs, ... }:
        {
          deployment.targetHost = "goodsprings.josch557.de";

          imports = [
            ./hosts/goodsprings.nix
            simple-nixos-mailserver.nixosModule
          ];
        };

    };

  };

}
