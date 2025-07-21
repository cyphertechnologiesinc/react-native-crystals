cmake_minimum_required(VERSION 3.18.1)

project(reactnativekyber)

# Add your Kyber C implementation files
file(GLOB KYBER_SOURCES "kyber-c/*.c")

# Add your Dilithium C implementation files (now including randombytesd.c since we renamed the function)
file(GLOB DILITHIUM_SOURCES "dilithium-c/*.c")

add_library(
    reactnativekyber
    SHARED
    ../cpp/KyberModule.cpp
    ../cpp/DilithiumModule.cpp
    ${KYBER_SOURCES}
    ${DILITHIUM_SOURCES}
)

target_include_directories(
    reactnativekyber
    PRIVATE
    kyber-c/
    dilithium-c/
)

target_compile_definitions(
    reactnativekyber
    PRIVATE
    KYBER_K=3  # For Kyber768
    DILITHIUM_NAMESPACE=pqcrystals_dilithium3_ref
)

find_library(log-lib log)

target_link_libraries(
    reactnativekyber
    ${log-lib}
)