import Foundation

@objc(ReactNativeKyber)
class ReactNativeKyberPackage: NSObject {
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    @objc
    static func moduleName() -> String {
        return "ReactNativeKyber"
    }
} 