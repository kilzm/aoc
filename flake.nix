{
  description = "solutions to advent of code";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          aoc2020 = pkgs.callPackage ./cpp20 {};
        };

        apps = rec {
        };
      }
    );
}
