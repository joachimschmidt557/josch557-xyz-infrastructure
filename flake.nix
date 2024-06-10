{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";

  outputs = { self, nixpkgs, simple-nixos-mailserver }: {

    nixopsConfigurations.default = {

      inherit nixpkgs;

      network = {
        description = "production environment";
        enableRollback = true;
        storage.legacy.databasefile = "~/.nixops/deployments.nixops";
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
