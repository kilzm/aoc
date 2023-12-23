{ lib
, stdenv
, odin
}:

stdenv.mkDerivation {
  name = "aoc2023";

  src = ./.;

  nativeBuildInputs = [
    odin
  ];

  buildPhase = ''
    odin build aoc -out:aoc2023 -o:aggressive -no-bounds-check
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp aoc2023 $out/bin
  '';
}
