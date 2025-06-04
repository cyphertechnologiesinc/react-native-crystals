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
declare const _default: KyberInterface;
export default _default;
//# sourceMappingURL=index.d.ts.map