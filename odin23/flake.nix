{
  description = "solutions to advent of code 2023 in Odin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [
        (final: prev: {
          odin = prev.odin.overrideAttrs(old: {
            version = "dev-2023-12";
            src = old.src.override {
              hash = "sha256-5plcr+j9aFSaLfLQXbG4WD1GH6rE7D3uhlUbPaDEYf8=";
            };
          });
         })
      ];
    in
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs {
          inherit system overlays; 
        };
      in
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
