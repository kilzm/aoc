{
  description = "solutions to advent of code 2020 in c++";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          cpp20 = pkgs.callPackage ./. { stdenv = pkgs.gcc13Stdenv; };
          default = cpp20;
        };

        apps = rec {
          cpp20 = flake-utils.lib.mkApp { drv = self.packages.${system}.cpp20; };
          default = cpp20;
        };
      }
    );
}
