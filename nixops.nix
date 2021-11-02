{
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
}
