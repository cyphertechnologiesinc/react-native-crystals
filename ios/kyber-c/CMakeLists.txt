cmake_minimum_required(VERSION 3.4.1)

project(native_modules)

# Add your Kyber library (keep your existing code)
add_library(kyber SHARED
    ${CMAKE_SOURCE_DIR}/KyberModule.cpp
    ${CMAKE_SOURCE_DIR}/kyber_wrapper.c
    ${CMAKE_SOURCE_DIR}/cbd.c
    ${CMAKE_SOURCE_DIR}/fips202.c
    ${CMAKE_SOURCE_DIR}/indcpa.c
    ${CMAKE_SOURCE_DIR}/kem.c
    ${CMAKE_SOURCE_DIR}/ntt.c
    ${CMAKE_SOURCE_DIR}/poly.c
    ${CMAKE_SOURCE_DIR}/polyvec.c
    ${CMAKE_SOURCE_DIR}/randombytes.c
    ${CMAKE_SOURCE_DIR}/reduce.c
    ${CMAKE_SOURCE_DIR}/symmetric-shake.c
    ${CMAKE_SOURCE_DIR}/verify.c
)

# Add the simple module as a new target
add_library(simplemodule SHARED
    ${CMAKE_SOURCE_DIR}/SimpleModule.cpp
)

# Include directories (for both modules)
include_directories(
    ${CMAKE_SOURCE_DIR}
)

# Find the log library
find_library(log-lib log)

# Link both libraries with the log library
target_link_libraries(kyber ${log-lib})
target_link_libraries(simplemodule ${log-lib})