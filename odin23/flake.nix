{
  description = "solutions to advent of code 2023 in Odin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.odin-overlay.url = "github:kilzm/odin-overlay";

  outputs = { self, nixpkgs, flake-utils, odin-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs {
          inherit system;
        };
        odin-pkgs = odin-overlay.packages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with odin-pkgs; [
              odin-latest
              ols
            ];
          };
        };

        packages = rec {
          odin23 = pkgs.callPackage ./. { odin = odin-pkgs.odin-latest; };
          odin23-fast = pkgs.callPackage ./. { odin = odin-pkgs.odin-sroa-pass; };
          default = odin23-fast;
        };

        apps = rec {
          odin23-fast = flake-utils.lib.mkApp { drv = self.packages.${system}.odin23-fast; };
          default = odin23-fast;
        };
      }
    );
}
