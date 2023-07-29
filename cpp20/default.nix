{ stdenv
, lib
, cmake
}:

stdenv.mkDerivation {
  pname = "aoc2020";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [];
}