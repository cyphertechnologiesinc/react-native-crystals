require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "ReactNativeKyber"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/CascadiaTech/react-native-kyber.git", :tag => "#{s.version}" }

  # Include all source files in a single array
  s.source_files = [
    "ios/ReactNativeKyber/**/*.{h,m,mm,swift,c}",
    "ios/kyber-c/kem.c",
    "ios/kyber-c/indcpa.c", 
    "ios/kyber-c/polyvec.c",
    "ios/kyber-c/poly.c",
    "ios/kyber-c/ntt.c",
    "ios/kyber-c/cbd.c",
    "ios/kyber-c/reduce.c",
    "ios/kyber-c/verify.c",
    "ios/kyber-c/symmetric-shake.c",
    "ios/kyber-c/randombytes.c",
    "ios/kyber-c/fips202.c",
    "ios/dilithium-c/sign.c",
    "ios/dilithium-c/packing.c",
    "ios/dilithium-c/polyvec.c",
    "ios/dilithium-c/poly.c",
    "ios/dilithium-c/ntt.c",
    "ios/dilithium-c/reduce.c",
    "ios/dilithium-c/rounding.c",
    "ios/dilithium-c/symmetric-shake.c",
    "ios/dilithium-c/randombytesd.c",
    "ios/dilithium-c/fips202.c"
  ]

  # Include header files separately to avoid umbrella conflicts
  s.private_header_files = [
    "ios/kyber-c/*.h",
    "ios/dilithium-c/*.h"
  ]

  # Only expose the bridging header and namespace headers in the umbrella
  s.public_header_files = [
    "ios/ReactNativeKyber/ReactNativeKyber-Bridging-Header.h",
    "ios/ReactNativeKyber/kyber_namespace.h",
    "ios/ReactNativeKyber/dilithium_namespace.h"
  ]

  s.requires_arc = true
  s.swift_version = "5.0"

  s.dependency "React-Core"
  s.dependency "ReactCommon" 

  # Compiler settings for C code
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES",
    "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "ReactNativeKyber-Swift.h",
    "OTHER_CFLAGS" => "-DKYBER_K=3 -DDILITHIUM_MODE=3 -Wall -Wextra -O3",
    "HEADER_SEARCH_PATHS" => "$(PODS_TARGET_SRCROOT)/ios/kyber-c $(PODS_TARGET_SRCROOT)/ios/dilithium-c $(PODS_TARGET_SRCROOT)/ios/ReactNativeKyber",
    "GCC_PREPROCESSOR_DEFINITIONS" => "KYBER_K=3 DILITHIUM_MODE=3"
  }

  # Add C source files to compilation with proper flags
  s.compiler_flags = "-DKYBER_K=3 -DDILITHIUM_MODE=3"
end