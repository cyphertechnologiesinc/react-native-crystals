import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-kyber' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- Use Xcode 12.0 or newer for iOS development\n", default: '' }) +
  '- NPM: npm uninstall react-native-kyber && npm install react-native-kyber\n' +
  '- Yarn: yarn remove react-native-kyber && yarn add react-native-kyber\n' +
  Platform.select({ ios: "- Run 'cd ios && pod install'\n", default: '' }) +
  '- Rebuild the app (\`npx react-native run-ios\` for iOS or \`npx react-native run-android\` for Android)\n';

const KyberModule = NativeModules.Kyber
  ? NativeModules.Kyber
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const DilithiumModule = NativeModules.Dilithium
  ? NativeModules.Dilithium
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface KyberKeyPair {
  publicKey: string;  // Base64 encoded
  secretKey: string;  // Base64 encoded
}

export interface KyberEncryptResult {
  ciphertext: string;    // Base64 encoded
  sharedSecret: string;  // Base64 encoded
}

export interface KyberDecryptResult {
  sharedSecret: string;  // Base64 encoded
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
  publicKey: string;  // Base64 encoded
  secretKey: string;  // Base64 encoded
}

export interface DilithiumSignResult {
  signature: string;  // Base64 encoded
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

// Export both modules
export const Kyber = KyberModule as KyberInterface;
export const Dilithium = DilithiumModule as DilithiumInterface;

// Default export for backward compatibility (Kyber)
export default KyberModule as KyberInterface;