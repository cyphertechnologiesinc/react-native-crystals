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

  # Include all your source files
  s.source_files = [
    "ios/ReactNativeKyber/**/*.{h,m,mm,swift}", 
    "ios/kyber-c/*.{h,c}",  # Only root kyber-c files
  ]
  


  s.requires_arc = true
  s.swift_version = "5.0"

  s.dependency "React-Core"
  s.dependency "ReactCommon" 

  # Compiler settings for C code
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES",
    "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "ReactNativeKyber-Swift.h",  # ← Explicit name
    "OTHER_CFLAGS" => "-DKYBER_K=3",
    "HEADER_SEARCH_PATHS" => "$(PODS_TARGET_SRCROOT)/ios/kyber-c"
  }
end