{ stdenv
, lib
, cmake
, re2
}:

stdenv.mkDerivation {
  pname = "aoc2020";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ re2 ];
}
