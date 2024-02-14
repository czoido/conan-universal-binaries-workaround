cmake_minimum_required(VERSION 3.15)
project(example LANGUAGES CXX)

find_package(fmt REQUIRED CONFIG)

add_executable(example example.cpp)
target_compile_features(example PRIVATE cxx_std_14)
target_link_libraries(example PRIVATE fmt::fmt)
