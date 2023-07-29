cmake_minimum_required(VERSION 3.20)
project(aoc2020 CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -O3")
set(CMAKE_CXX_FLAGS_DEBUG "-g")

find_package(OpenMP REQUIRED)
if(OPENMP_FOUND)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

find_package(re2 REQUIRED)

include_directories(include)
add_subdirectory(src)

target_link_libraries(aoc2020 re2::re2)

install(TARGETS aoc2020 DESTINATION bin)
install(DIRECTORY ${CMAKE_SOURCE_DIR}/data DESTINATION .)