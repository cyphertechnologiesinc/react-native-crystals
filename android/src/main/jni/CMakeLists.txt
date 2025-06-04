cmake_minimum_required(VERSION 3.18.1)

project(reactnativekyber)

# Add your Kyber C implementation files
file(GLOB KYBER_SOURCES "kyber-c/*.c")

add_library(
    reactnativekyber
    SHARED
    ../cpp/KyberModule.cpp
    ${KYBER_SOURCES}
)

target_include_directories(
    reactnativekyber
    PRIVATE
    kyber-c/
)

target_compile_definitions(
    reactnativekyber
    PRIVATE
    KYBER_K=3  # For Kyber768
)

find_library(log-lib log)

target_link_libraries(
    reactnativekyber
    ${log-lib}
)