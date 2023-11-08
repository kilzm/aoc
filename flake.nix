{
  description = "solutions to advent of code";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.cpp20.url = "path:./cpp20";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          cpp20 = inputs.cpp20.packages.${system}.cpp20;
        };

        apps = rec {
          cpp20 = inputs.cpp20.apps.${system}.cpp20;
        };
      }
    );
}
