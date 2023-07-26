mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
rm -f $(pwd)/../aoc
ln -s $(pwd)/aoc $(pwd)/../aoc