import Foundation

@objc(Kyber)
class KyberModule: NSObject {
    
    // MARK: - Kyber768 Constants (matching your Android C++ code)
    private let KYBER_PUBLICKEYBYTES: Int = 1184   // Kyber768 public key size
    private let KYBER_SECRETKEYBYTES: Int = 2400   // Kyber768 secret key size  
    private let KYBER_CIPHERTEXTBYTES: Int = 1088  // Kyber768 ciphertext size
    private let KYBER_SSBYTES: Int = 32            // Shared secret size
    
    // MARK: - React Native Methods
    
    @objc
    func hello(_ resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        resolve("Hello from Kyber Module!")
    }
    
    @objc
    func generateKeyPair(_ resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Allocate memory for keys
        let publicKeyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: KYBER_PUBLICKEYBYTES)
        let secretKeyPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: KYBER_SECRETKEYBYTES)
        
        defer {
            publicKeyPtr.deallocate()
            secretKeyPtr.deallocate()
        }
        
        // Call the wrapper function
        let result = kyber_keypair_wrapper(publicKeyPtr, secretKeyPtr)
        
        if result == 0 {
            // Convert to Data
            let publicKeyData = Data(bytes: publicKeyPtr, count: KYBER_PUBLICKEYBYTES)
            let secretKeyData = Data(bytes: secretKeyPtr, count: KYBER_SECRETKEYBYTES)
            
            let resultDict: [String: String] = [
                "publicKey": publicKeyData.base64EncodedString(),
                "secretKey": secretKeyData.base64EncodedString()
            ]
            
            resolve(resultDict)
        }
        // If it fails, just don't call resolve - JavaScript will handle timeout
    }
    
    @objc
    func encrypt(_ publicKeyBase64: String, resolver resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Decode the base64 public key
        guard let publicKeyData = Data(base64Encoded: publicKeyBase64) else {
            return // Just return early on error
        }
        
        guard publicKeyData.count == KYBER_PUBLICKEYBYTES else {
            return // Just return early on error
        }
        
        // Allocate memory for outputs
        let ciphertextPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: KYBER_CIPHERTEXTBYTES)
        let sharedSecretPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: KYBER_SSBYTES)
        
        defer {
            ciphertextPtr.deallocate()
            sharedSecretPtr.deallocate()
        }
        
        // Call the wrapper function
        let result = publicKeyData.withUnsafeBytes { pubKeyBytes in
            kyber_enc_wrapper(ciphertextPtr, sharedSecretPtr, pubKeyBytes.bindMemory(to: UInt8.self).baseAddress!)
        }
        
        if result == 0 {
            // Convert to Data
            let ciphertextData = Data(bytes: ciphertextPtr, count: KYBER_CIPHERTEXTBYTES)
            let sharedSecretData = Data(bytes: sharedSecretPtr, count: KYBER_SSBYTES)
            
            let resultDict: [String: String] = [
                "ciphertext": ciphertextData.base64EncodedString(),
                "sharedSecret": sharedSecretData.base64EncodedString()
            ]
            
            resolve(resultDict)
        }
        // If it fails, just don't call resolve
    }
    
    @objc
    func decrypt(_ ciphertextBase64: String, secretKeyBase64: String, resolver resolve: @escaping (Any?) -> Void, rejecter reject: @escaping (String?, String?, Error?) -> Void) {
        // Decode the base64 inputs
        guard let ciphertextData = Data(base64Encoded: ciphertextBase64) else {
            return // Just return early on error
        }
        
        guard let secretKeyData = Data(base64Encoded: secretKeyBase64) else {
            return // Just return early on error
        }
        
        guard ciphertextData.count == KYBER_CIPHERTEXTBYTES else {
            return // Just return early on error
        }
        
        guard secretKeyData.count == KYBER_SECRETKEYBYTES else {
            return // Just return early on error
        }
        
        // Allocate memory for output
        let sharedSecretPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: KYBER_SSBYTES)
        
        defer {
            sharedSecretPtr.deallocate()
        }
        
        // Call the wrapper function
        let result = ciphertextData.withUnsafeBytes { ciphertextBytes in
            secretKeyData.withUnsafeBytes { secretKeyBytes in
                kyber_dec_wrapper(sharedSecretPtr,
                              ciphertextBytes.bindMemory(to: UInt8.self).baseAddress!,
                              secretKeyBytes.bindMemory(to: UInt8.self).baseAddress!)
            }
        }
        
        if result == 0 {
            // Convert to Data
            let sharedSecretData = Data(bytes: sharedSecretPtr, count: KYBER_SSBYTES)
            
            let resultDict: [String: String] = [
                "sharedSecret": sharedSecretData.base64EncodedString()
            ]
            
            resolve(resultDict)
        }
        // If it fails, just don't call resolve
    }
}

// MARK: - C Function Declarations (using wrapper functions)
@_silgen_name("kyber_keypair_wrapper")
func kyber_keypair_wrapper(_ pk: UnsafeMutablePointer<UInt8>, _ sk: UnsafeMutablePointer<UInt8>) -> Int32

@_silgen_name("kyber_enc_wrapper")
func kyber_enc_wrapper(_ ct: UnsafeMutablePointer<UInt8>, _ ss: UnsafeMutablePointer<UInt8>, _ pk: UnsafePointer<UInt8>) -> Int32

@_silgen_name("kyber_dec_wrapper")
func kyber_dec_wrapper(_ ss: UnsafeMutablePointer<UInt8>, _ ct: UnsafePointer<UInt8>, _ sk: UnsafePointer<UInt8>) -> Int32
