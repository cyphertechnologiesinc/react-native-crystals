export interface KyberKeyPair {
    publicKey: string;
    secretKey: string;
}
export interface KyberEncryptResult {
    ciphertext: string;
    sharedSecret: string;
}
export interface KyberDecryptResult {
    sharedSecret: string;
}
export interface KyberInterface {
    /**
     * Simple hello method for testing the module connection
     */
    hello(): Promise<string>;
    /**
     * Generate a new Kyber768 key pair
     * @returns Promise resolving to a key pair with base64 encoded keys
     */
    generateKeyPair(): Promise<KyberKeyPair>;
    /**
     * Encrypt using a public key to generate ciphertext and shared secret
     * @param publicKeyBase64 Base64 encoded public key
     * @returns Promise resolving to ciphertext and shared secret (both base64 encoded)
     */
    encrypt(publicKeyBase64: string): Promise<KyberEncryptResult>;
    /**
     * Decrypt ciphertext using secret key to recover shared secret
     * @param ciphertextBase64 Base64 encoded ciphertext
     * @param secretKeyBase64 Base64 encoded secret key
     * @returns Promise resolving to the shared secret (base64 encoded)
     */
    decrypt(ciphertextBase64: string, secretKeyBase64: string): Promise<KyberDecryptResult>;
}
export interface DilithiumKeyPair {
    publicKey: string;
    secretKey: string;
}
export interface DilithiumSignResult {
    signature: string;
}
export interface DilithiumVerifyResult {
    isValid: boolean;
}
export interface DilithiumInterface {
    /**
     * Simple hello method for testing the module connection
     */
    hello(): Promise<string>;
    /**
     * Generate a new Dilithium3 key pair
     * @returns Promise resolving to a key pair with base64 encoded keys
     */
    generateKeyPair(): Promise<DilithiumKeyPair>;
    /**
     * Sign a message using a secret key
     * @param message The message to sign
     * @param secretKeyBase64 Base64 encoded secret key
     * @returns Promise resolving to the signature (base64 encoded)
     */
    sign(message: string, secretKeyBase64: string): Promise<DilithiumSignResult>;
    /**
     * Verify a signature using a public key
     * @param message The original message
     * @param signatureBase64 Base64 encoded signature
     * @param publicKeyBase64 Base64 encoded public key
     * @returns Promise resolving to verification result
     */
    verify(message: string, signatureBase64: string, publicKeyBase64: string): Promise<DilithiumVerifyResult>;
}
export declare const Kyber: KyberInterface;
export declare const Dilithium: DilithiumInterface;
declare const _default: KyberInterface;
export default _default;
//# sourceMappingURL=index.d.ts.map