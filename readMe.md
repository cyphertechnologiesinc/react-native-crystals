
# React Native Kyber & Dilithium

A React Native module for post-quantum cryptography, providing both Kyber768 for key exchange and Dilithium3 for digital signatures. This package enables developers to implement post-quantum cryptographic operations in React Native applications for both iOS and Android platforms. Details on the source code are located below as well as instructions on how to utilize this package

## Features

- 🔐 **Post-Quantum Security**: Implementation of Kyber768 (key exchange) and Dilithium3 (digital signatures)
- 📱 **Cross-Platform**: Works on both iOS and Android
- 🚀 **Easy Integration**: Simple NPM install with auto-linking
- 💪 **TypeScript Support**: Full type definitions included
- ⚡ **Performance**: Native C implementation for optimal speed
- 🛡️ **Memory Safe**: Proper memory management on both platforms
- 🔑 **Dual Functionality**: Both key exchange and digital signatures in one package

**Kyber768**: Key encapsulation mechanism for secure key exchange
**Dilithium3**: Digital signature algorithm for authentication and integrity

## Installation

```bash
npm install react-native-kyber
# or
yarn add react-native-kyber
```

### iOS Setup

```bash
cd ios && pod install

testing has been done on IPhone15 and up 
```

### Android Setup

No additional setup required. The module uses auto-linking.

## Quick Start

```javascript
import { Kyber, Dilithium } from 'react-native-kyber';

async function demonstratePostQuantumCrypto() {
  try {
    // === KYBER KEY EXCHANGE ===
    console.log('🔐 Testing Kyber Key Exchange...');
    
    // Generate a key pair
    const kyberKeyPair = await Kyber.generateKeyPair();
    console.log('Kyber key pair generated!');
    
    // Encrypt (generates ciphertext and shared secret)
    const encryptResult = await Kyber.encrypt(kyberKeyPair.publicKey);
    console.log('Kyber encryption complete!');
    
    // Decrypt (recovers the same shared secret)
    const decryptResult = await Kyber.decrypt(
      encryptResult.ciphertext,
      kyberKeyPair.secretKey
    );
    
    // Verify the shared secrets match
    const secretsMatch = encryptResult.sharedSecret === decryptResult.sharedSecret;
    console.log('Kyber shared secrets match:', secretsMatch);
    
    // === DILITHIUM DIGITAL SIGNATURES ===
    console.log('✍️ Testing Dilithium Digital Signatures...');
    
    // Generate a key pair
    const dilithiumKeyPair = await Dilithium.generateKeyPair();
    console.log('Dilithium key pair generated!');
    
    // Sign a message
    const message = "Hello, post-quantum world!";
    const signature = await Dilithium.sign(message, dilithiumKeyPair.secretKey);
    console.log('Message signed!');
    
    // Verify the signature
    const isValid = await Dilithium.verify(message, signature.signature, dilithiumKeyPair.publicKey);
    console.log('Signature verification:', isValid.isValid);
    
  } catch (error) {
    console.error('Post-quantum operation failed:', error);
  }
}
```

## API Reference

### Kyber (Key Exchange)

#### `Kyber.generateKeyPair(): Promise<KyberKeyPair>`

Generates a new Kyber768 key pair.

**Returns:**
```typescript
interface KyberKeyPair {
  publicKey: string;  // Base64 encoded public key (1184 bytes)
  secretKey: string;  // Base64 encoded secret key (2400 bytes)
}
```

#### `Kyber.encrypt(publicKeyBase64: string): Promise<KyberEncryptResult>`

Encrypts using a public key to generate ciphertext and shared secret.

**Parameters:**
- `publicKeyBase64` (string): Base64 encoded public key

**Returns:**
```typescript
interface KyberEncryptResult {
  ciphertext: string;    // Base64 encoded ciphertext (1088 bytes)
  sharedSecret: string;  // Base64 encoded shared secret (32 bytes)
}
```

#### `Kyber.decrypt(ciphertextBase64: string, secretKeyBase64: string): Promise<KyberDecryptResult>`

Decrypts ciphertext using secret key to recover shared secret.

**Parameters:**
- `ciphertextBase64` (string): Base64 encoded ciphertext
- `secretKeyBase64` (string): Base64 encoded secret key

**Returns:**
```typescript
interface KyberDecryptResult {
  sharedSecret: string;  // Base64 encoded shared secret (32 bytes)
}
```

#### `Kyber.hello(): Promise<string>`

Simple test method to verify the Kyber module is working correctly.

---

### Dilithium (Digital Signatures)

#### `Dilithium.generateKeyPair(): Promise<DilithiumKeyPair>`

Generates a new Dilithium3 key pair.

**Returns:**
```typescript
interface DilithiumKeyPair {
  publicKey: string;  // Base64 encoded public key (1952 bytes)
  secretKey: string;  // Base64 encoded secret key (4000 bytes)
}
```

#### `Dilithium.sign(message: string, secretKeyBase64: string): Promise<DilithiumSignResult>`

Signs a message using a secret key.

**Parameters:**
- `message` (string): The message to sign
- `secretKeyBase64` (string): Base64 encoded secret key

**Returns:**
```typescript
interface DilithiumSignResult {
  signature: string;  // Base64 encoded signature (2701 bytes)
}
```

#### `Dilithium.verify(message: string, signatureBase64: string, publicKeyBase64: string): Promise<DilithiumVerifyResult>`

Verifies a signature using a public key.

**Parameters:**
- `message` (string): The original message
- `signatureBase64` (string): Base64 encoded signature
- `publicKeyBase64` (string): Base64 encoded public key

**Returns:**
```typescript
interface DilithiumVerifyResult {
  isValid: boolean;  // Whether the signature is valid
}
```

#### `Dilithium.hello(): Promise<string>`

Simple test method to verify the Dilithium module is working correctly.

---

## Error Handling

All methods return promises that will reject with descriptive error messages:

```javascript
try {
  const kyberKeyPair = await Kyber.generateKeyPair();
  const dilithiumKeyPair = await Dilithium.generateKeyPair();
} catch (error) {
  switch (error.code) {
    case 'ERR_KEYGEN':
      console.error('Key generation failed');
      break;
    case 'ERR_ENCRYPT':
      console.error('Encryption failed');
      break;
    case 'ERR_DECRYPT':
      console.error('Decryption failed');
      break;
    case 'ERR_SIGN':
      console.error('Signing failed');
      break;
    case 'ERR_VERIFY':
      console.error('Verification failed');
      break;
    case 'ERR_INVALID_KEY':
      console.error('Invalid key provided');
      break;
    default:
      console.error('Unknown error:', error.message);
  }
}
```

## Security Considerations

### Key Storage
- **Never store secret keys in plain text**
- Use secure storage solutions like:
  - iOS: Keychain Services
  - Android: Android Keystore or EncryptedSharedPreferences
  - React Native: react-native-keychain

### Key Sizes

**Kyber768:**
- **Public Key**: 1184 bytes
- **Secret Key**: 2400 bytes  
- **Ciphertext**: 1088 bytes
- **Shared Secret**: 32 bytes

**Dilithium3:**
- **Public Key**: 1952 bytes
- **Secret Key**: 4000 bytes
- **Signature**: 2701 bytes

### Memory Management
- Keys are automatically cleared from memory after use
- No manual memory management required

## Use Cases

### 1. Secure Key Exchange with Kyber
```javascript
// Alice generates key pair
const aliceKeyPair = await Kyber.generateKeyPair();

// Alice sends public key to Bob (this can be sent over insecure channel)
const alicePublicKey = aliceKeyPair.publicKey;

// Bob encrypts using Alice's public key
const bobEncryptResult = await Kyber.encrypt(alicePublicKey);

// Bob sends ciphertext to Alice (this can be sent over insecure channel)
const ciphertext = bobEncryptResult.ciphertext;

// Alice decrypts to get the same shared secret
const aliceDecryptResult = await Kyber.decrypt(ciphertext, aliceKeyPair.secretKey);

// Both parties now have the same shared secret
const sharedSecret = aliceDecryptResult.sharedSecret;
```

### 2. Digital Signatures with Dilithium
```javascript
// Generate a key pair for signing
const signerKeyPair = await Dilithium.generateKeyPair();

// Sign a message
const message = "Important document content";
const signature = await Dilithium.sign(message, signerKeyPair.secretKey);

// Send message and signature to verifier
// (public key can be shared publicly)

// Verifier checks the signature
const isValid = await Dilithium.verify(message, signature.signature, signerKeyPair.publicKey);
console.log('Signature is valid:', isValid.isValid);
```

### 3. Combined Post-Quantum Security
```javascript
// Generate keys for both operations
const kyberKeyPair = await Kyber.generateKeyPair();
const dilithiumKeyPair = await Dilithium.generateKeyPair();

// Establish secure channel with Kyber
const encryptResult = await Kyber.encrypt(kyberKeyPair.publicKey);
const decryptResult = await Kyber.decrypt(encryptResult.ciphertext, kyberKeyPair.secretKey);

// Sign the shared secret with Dilithium
const signature = await Dilithium.sign(decryptResult.sharedSecret, dilithiumKeyPair.secretKey);

// Verify the signature
const isValid = await Dilithium.verify(decryptResult.sharedSecret, signature.signature, dilithiumKeyPair.publicKey);
```

## Troubleshooting

### iOS Issues

**Pod install fails:**
```bash
cd ios
pod deintegrate
pod install
```

**Build errors:**
- Ensure Xcode 16.0+ is being used
- Check that all C files are included in the build
- "^0.72.6" react-native

### Android Issues

**Library not found:**
- Clean and rebuild: `cd android && ./gradlew clean`
- Verify NDK is properly installed

**CMake errors:**
- Ensure CMake 3.18.1+ is available
- Check that all C files are in the correct directory

### General Issues

**Module not found:**
```bash
# Clear React Native cache
npx react-native start --reset-cache

# Reinstall node modules
rm -rf node_modules package-lock.json
npm install
```

**TypeScript errors:**
```bash
# Ensure types are properly installed
npm install --save-dev @types/react-native
```

## Performance

- **Kyber Key Generation**: ~1-2ms on modern devices
- **Kyber Encryption**: ~0.5-1ms on modern devices  
- **Kyber Decryption**: ~0.5-1ms on modern devices
- **Dilithium Key Generation**: ~2-3ms on modern devices
- **Dilithium Signing**: ~1-2ms on modern devices
- **Dilithium Verification**: ~0.5-1ms on modern devices
- **Memory Usage**: Minimal, automatic cleanup

## Compatibility

- **React Native**: 0.60+
- **iOS**: 11.0+
- **Android**: API 21+ (Android 5.0)
- **Node.js**: 16+

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Install dependencies: `npm install`
3. Set up the example app: `npm run example`
4. Run tests: `npm test`

## License

MIT

---

# Local Testing Guide

## Prerequisites

Before testing, ensure you have:
- Node.js 16+
- React Native CLI
- iOS: Xcode 12.0+, CocoaPods
- Android: Android Studio, NDK

## Testing Script

### 1. Run Test Script (`test-local.sh`) 

This will create a sample application that can run on both IOS and android to show the library works, its a little over the top. 

```bash
chmod +x test-local.sh
./test-local.sh
```

## Manual Testing Steps

If you prefer manual testing:

### 1. Build and Pack Your Package

```bash
# In your react-native-kyber directory
npm run prepack
npm pack
```

### 2. Create Test Project

```bash
# Go to parent directory
cd ..

# Create new React Native project
npx react-native init KyberTestApp --version 0.72.6
cd KyberTestApp

# Install your local package
npm install ../react-native-kyber/react-native-kyber-*.tgz

# iOS setup
cd ios && pod install && cd ..
```

### 3. Usage Example

Create `TestBoth.js`:

```javascript
import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, ScrollView } from 'react-native';
import { Kyber, Dilithium } from 'react-native-kyber';

const TestBoth = () => {
  const [log, setLog] = useState('Ready to test...\n');

  const addLog = (msg) => setLog(prev => prev + `${msg}\n`);

  const testBoth = async () => {
    setLog('Testing Kyber & Dilithium...\n');
    
    try {
      // Test Kyber
      addLog('🔐 Testing Kyber...');
      const kyberKeys = await Kyber.generateKeyPair();
      addLog('✅ Kyber Keys generated');
      
      const kyberEnc = await Kyber.encrypt(kyberKeys.publicKey);
      addLog('✅ Kyber Encrypted');
      
      const kyberDec = await Kyber.decrypt(kyberEnc.ciphertext, kyberKeys.secretKey);
      const kyberMatch = kyberEnc.sharedSecret === kyberDec.sharedSecret;
      addLog(kyberMatch ? '🎉 Kyber SUCCESS' : '❌ Kyber FAIL');
      
      // Test Dilithium
      addLog('✍️ Testing Dilithium...');
      const dilithiumKeys = await Dilithium.generateKeyPair();
      addLog('✅ Dilithium Keys generated');
      
      const message = "Hello, post-quantum world!";
      const signature = await Dilithium.sign(message, dilithiumKeys.secretKey);
      addLog('✅ Dilithium Signed');
      
      const verify = await Dilithium.verify(message, signature.signature, dilithiumKeys.publicKey);
      addLog(verify.isValid ? '🎉 Dilithium SUCCESS' : '❌ Dilithium FAIL');
      
    } catch (error) {
      addLog(`❌ Error: ${error.message}`);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={testBoth}>
        <Text style={styles.buttonText}>Test Both</Text>
      </TouchableOpacity>
      <ScrollView style={styles.log}>
        <Text style={styles.logText}>{log}</Text>
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20 },
  button: { backgroundColor: '#007AFF', padding: 15, borderRadius: 8, marginBottom: 20 },
  buttonText: { color: 'white', textAlign: 'center', fontSize: 18 },
  log: { flex: 1, backgroundColor: '#000', borderRadius: 8, padding: 10 },
  logText: { color: '#0f0', fontFamily: 'Courier', fontSize: 14 },
});

export default TestBoth;
```

### 4. Run Tests

```bash
# iOS
npx react-native run-ios

# Android  
npx react-native run-android
```

## What to Expect

When the tests run successfully, you should see:
- ✅ Kyber hello message from native module
- ✅ Kyber key pair generation with proper lengths
- ✅ Kyber encryption producing ciphertext and shared secret
- ✅ Kyber decryption recovering the same shared secret
- ✅ Kyber shared secrets matching between encrypt/decrypt
- ✅ Dilithium hello message from native module
- ✅ Dilithium key pair generation with proper lengths
- ✅ Dilithium signing producing valid signature
- ✅ Dilithium verification confirming signature validity

## Common Issues & Solutions

### Package not found
```bash
# Clear cache
npx react-native start --reset-cache
rm -rf node_modules && npm install
```

### iOS build errors
```bash
cd ios
pod deintegrate
pod install
```

### Android build errors
```bash
cd android
./gradlew clean
cd ..
npx react-native run-android
```


### Kyber and Dilithium Source code

The Source code can be found here: https://github.com/pq-crystals this is the Official 
reference implementation for Kyber and Dilithium as defined here: https://pq-crystals.org/

We exposed the recommended Kyber and Dilithium modes, we may expand to all modes in the future, 
if the source code is updated, this package will also implement the update

Cypher Technologies Co DID NOT make this code, nor do we claim any ownership over it. 

This is open source software provided as is. 


## Dev Testing

To see how the package works, fork the project and run ./test-local.sh. This will create a folder called KyberTestApp -> run npx-react-native run-ios or run-android to have a project to validate cryptographic operations. 

