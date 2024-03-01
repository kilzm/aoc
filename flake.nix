{
  description = "solutions to advent of code";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=23.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.cpp20.url = "path:./cpp20";
  inputs.odin23.url = "path:./odin23";

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          cpp20 = inputs.cpp20.packages.${system}.default;
          odin23 = inputs.odin23.packages.${system}.default;
        };

        apps = {
          cpp20 = inputs.cpp20.apps.${system}.default;
          odin23 = inputs.odin23.apps.${system}.default;
        };
      }
    );
}
