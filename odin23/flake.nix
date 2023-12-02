{
  description = "solutions to advent of code 2023 in Odin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              odin
            ];
          };
        };

        packages = rec {
          odin23 = pkgs.callPackage ./. { stdenv = pkgs.gcc13Stdenv; };
          default = odin23;
        };

        apps = rec {
          odin23 = flake-utils.lib.mkApp { drv = self.packages.${system}.odin23; };
          default = odin23;
        };
      }
    );
}
