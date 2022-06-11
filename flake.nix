{

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }: {

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
          imports = [ ./hosts/goodsprings.nix ];
        };

    };

  };

}
