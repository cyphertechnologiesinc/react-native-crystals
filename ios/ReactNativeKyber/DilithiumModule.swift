import Foundation

@objc(Dilithium)
class DilithiumModule: NSObject {
    
    // MARK: - Dilithium3 Constants
    private let DILITHIUM_PUBLICKEYBYTES: Int = 1952   // Dilithium3 public key size
    private let DILITHIUM_SECRETKEYBYTES: Int = 4032   // Dilithium3 secret key size  
    private let DILITHIUM_SIGNATUREBYTES: Int = 3309   // Dilithium3 signature size
    
    // MARK: - React Native Methods
    
    @objc
    func hello(_ resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        resolve("Hello from Dilithium Module!")
    }
    
    @objc
    func generateKeyPair(_ resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Allocate memory for keys
        let publicKeyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: DILITHIUM_PUBLICKEYBYTES)
        let secretKeyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: DILITHIUM_SECRETKEYBYTES)
        
        defer {
            publicKeyPtr.deallocate()
            secretKeyPtr.deallocate()
        }
        
        // Call the wrapper function
        let result = dilithium_keypair_wrapper(publicKeyPtr, secretKeyPtr)
        
        if result == 0 {
            // Convert to Data
            let publicKeyData = Data(bytes: publicKeyPtr, count: DILITHIUM_PUBLICKEYBYTES)
            let secretKeyData = Data(bytes: secretKeyPtr, count: DILITHIUM_SECRETKEYBYTES)
            
            let resultDict: [String: String] = [
                "publicKey": publicKeyData.base64EncodedString(),
                "secretKey": secretKeyData.base64EncodedString()
            ]
            
            resolve(resultDict)
        }
        // If it fails, just don't call resolve - JavaScript will handle timeout
    }
    
    @objc
    func sign(_ message: String, secretKeyBase64: String, resolver resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Decode the base64 secret key
        guard let secretKeyData = Data(base64Encoded: secretKeyBase64) else {
            return // Just return early on error
        }
        
        guard secretKeyData.count == DILITHIUM_SECRETKEYBYTES else {
            return // Just return early on error
        }
        
        // Convert message to bytes
        guard let messageData = message.data(using: .utf8) else {
            return // Just return early on error
        }
        
        // Allocate memory for signature
        let signaturePtr = UnsafeMutablePointer<UInt8>.allocate(capacity: DILITHIUM_SIGNATUREBYTES)
        var signatureLen: size_t = 0
        
        defer {
            signaturePtr.deallocate()
        }
        
        // Call the wrapper function
        let result = messageData.withUnsafeBytes { messageBytes in
            secretKeyData.withUnsafeBytes { secretKeyBytes in
                dilithium_sign_wrapper(signaturePtr, &signatureLen, 
                                      messageBytes.bindMemory(to: UInt8.self).baseAddress!, 
                                      messageData.count,
                                      secretKeyBytes.bindMemory(to: UInt8.self).baseAddress!)
            }
        }
        
        if result == 0 {
            // Convert to Data
            let signatureData = Data(bytes: signaturePtr, count: Int(signatureLen))
            
            let resultDict: [String: String] = [
                "signature": signatureData.base64EncodedString()
            ]
            
            resolve(resultDict)
        }
        // If it fails, just don't call resolve
    }
    
    @objc
    func verify(_ message: String, signatureBase64: String, publicKeyBase64: String, resolver resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Decode the base64 inputs
        guard let signatureData = Data(base64Encoded: signatureBase64) else {
            return // Just return early on error
        }
        
        guard let publicKeyData = Data(base64Encoded: publicKeyBase64) else {
            return // Just return early on error
        }
        
        guard publicKeyData.count == DILITHIUM_PUBLICKEYBYTES else {
            return // Just return early on error
        }
        
        // Convert message to bytes
        guard let messageData = message.data(using: .utf8) else {
            return // Just return early on error
        }
        
        // Call the wrapper function
        let result = messageData.withUnsafeBytes { messageBytes in
            signatureData.withUnsafeBytes { signatureBytes in
                publicKeyData.withUnsafeBytes { publicKeyBytes in
                    dilithium_verify_wrapper(signatureBytes.bindMemory(to: UInt8.self).baseAddress!,
                                           signatureData.count,
                                           messageBytes.bindMemory(to: UInt8.self).baseAddress!,
                                           messageData.count,
                                           publicKeyBytes.bindMemory(to: UInt8.self).baseAddress!)
                }
            }
        }
        
        let resultDict: [String: Bool] = [
            "isValid": result == 0
        ]
        
        resolve(resultDict)
    }
}

// MARK: - C Function Declarations (using wrapper functions)
@_silgen_name("dilithium_keypair_wrapper")
func dilithium_keypair_wrapper(_ pk: UnsafeMutablePointer<UInt8>, _ sk: UnsafeMutablePointer<UInt8>) -> Int32

@_silgen_name("dilithium_sign_wrapper")
func dilithium_sign_wrapper(_ sig: UnsafeMutablePointer<UInt8>, _ siglen: UnsafeMutablePointer<size_t>, _ m: UnsafePointer<UInt8>, _ mlen: size_t, _ sk: UnsafePointer<UInt8>) -> Int32

@_silgen_name("dilithium_verify_wrapper")
func dilithium_verify_wrapper(_ sig: UnsafePointer<UInt8>, _ siglen: size_t, _ m: UnsafePointer<UInt8>, _ mlen: size_t, _ pk: UnsafePointer<UInt8>) -> Int32 
