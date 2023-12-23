{
  description = "solutions to advent of code 2023 in Odin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = [
        (final: prev: {
          odin = (prev.odin.overrideAttrs(old: {
            version = "034aead9301305d41756ef3b5b9b60a88c95d825";
            src = old.src.override {
              rev = "034aead9301305d41756ef3b5b9b60a88c95d825";
              hash = "sha256-okfcOlajq+r3oHH9zRHqaND4kIq3LWKYfEK7WTaI8hk=";
            };
          })).override {
            llvmPackages_13 = prev.llvmPackages_17;
          };
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
