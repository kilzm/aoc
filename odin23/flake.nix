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
              odin-dev-2024-02-sroa
              ols
            ];
          };
        };

        packages = rec {
          odin23 = pkgs.callPackage ./. { odin = odin-pkgs.odin-dev-2024-02-sroa; };
          default = odin23;
        };

        apps = rec {
          odin23 = flake-utils.lib.mkApp { drv = self.packages.${system}.odin23; };
          default = odin23;
        };
      }
    );
}
