
# React Native Kyber

A React Native module for Kyber post-quantum cryptography, providing secure key exchange using the Kyber768 algorithm. This package enables developers to implement post-quantum cryptographic operations in React Native applications for both iOS and Android platforms.

## Features

- 🔐 **Post-Quantum Security**: Implementation of Kyber768 algorithm
- 📱 **Cross-Platform**: Works on both iOS and Android
- 🚀 **Easy Integration**: Simple NPM install with auto-linking
- 💪 **TypeScript Support**: Full type definitions included
- ⚡ **Performance**: Native C implementation for optimal speed
- 🛡️ **Memory Safe**: Proper memory management on both platforms


https://github.com/pq-crystals/kyber/tree/main/ref C script source

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
import Kyber from 'react-native-kyber';

async function demonstrateKyber() {
  try {
    // Generate a key pair
    const keyPair = await Kyber.generateKeyPair();
    console.log('Key pair generated!');
    
    // Encrypt (generates ciphertext and shared secret)
    const encryptResult = await Kyber.encrypt(keyPair.publicKey);
    console.log('Encryption complete!');
    
    // Decrypt (recovers the same shared secret)
    const decryptResult = await Kyber.decrypt(
      encryptResult.ciphertext,
      keyPair.secretKey
    );
    
    // Verify the shared secrets match
    const secretsMatch = encryptResult.sharedSecret === decryptResult.sharedSecret;
    console.log('Shared secrets match:', secretsMatch);
    
  } catch (error) {
    console.error('Kyber operation failed:', error);
  }
}
```

## API Reference

### `generateKeyPair(): Promise<KyberKeyPair>`

Generates a new Kyber768 key pair.

**Returns:**
```typescript
interface KyberKeyPair {
  publicKey: string;  // Base64 encoded public key (1184 bytes)
  secretKey: string;  // Base64 encoded secret key (2400 bytes)
}
```

**Example:**
```javascript
const keyPair = await Kyber.generateKeyPair();
```

---

### `encrypt(publicKeyBase64: string): Promise<KyberEncryptResult>`

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

**Example:**
```javascript
const encryptResult = await Kyber.encrypt(keyPair.publicKey);
```

---

### `decrypt(ciphertextBase64: string, secretKeyBase64: string): Promise<KyberDecryptResult>`

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

**Example:**
```javascript
const decryptResult = await Kyber.decrypt(
  encryptResult.ciphertext,
  keyPair.secretKey
);
```

---

### `hello(): Promise<string>`

Simple test method to verify the module is working correctly.

**Returns:** Promise resolving to a test string

**Example:**
```javascript
const message = await Kyber.hello();
console.log(message); // "Hello from React Native Kyber!"
```

## Error Handling

All methods return promises that will reject with descriptive error messages:

```javascript
try {
  const keyPair = await Kyber.generateKeyPair();
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

### Key Sizes (Kyber768)
- **Public Key**: 1184 bytes
- **Secret Key**: 2400 bytes  
- **Ciphertext**: 1088 bytes
- **Shared Secret**: 32 bytes

### Memory Management
- Keys are automatically cleared from memory after use
- No manual memory management required

## Use Cases

### 1. Secure Key Exchange
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

### 2. Symmetric Key Generation
```javascript
// Generate a shared secret for symmetric encryption
const keyPair = await Kyber.generateKeyPair();
const encryptResult = await Kyber.encrypt(keyPair.publicKey);

// Use the shared secret as a key for AES encryption
const symmetricKey = encryptResult.sharedSecret;
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
- Ensure Xcode 12.0+ is being used
- Check that all Kyber C files are included in the build
- "0.72.6" react-native

### Android Issues

**Library not found:**
- Clean and rebuild: `cd android && ./gradlew clean`
- Verify NDK is properly installed

**CMake errors:**
- Ensure CMake 3.18.1+ is available
- Check that all Kyber C files are in the correct directory

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

- **Key Generation**: ~1-2ms on modern devices
- **Encryption**: ~0.5-1ms on modern devices  
- **Decryption**: ~0.5-1ms on modern devices
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

### 3. Useage Example

Create `TestSimple.js`:

```javascript
import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import Kyber from 'react-native-kyber';

const TestSimple = () => {
  const [result, setResult] = useState('Press test button');

  const testKyber = async () => {
    try {
      setResult('Testing...');
      
      // Test hello
      const hello = await Kyber.hello();
      setResult(`Hello: ${hello}`);
      
      // Test key generation
      const keyPair = await Kyber.generateKeyPair();
      setResult(prev => prev + `\nKeys generated!`);
      
      // Test encryption
      const encrypted = await Kyber.encrypt(keyPair.publicKey);
      setResult(prev => prev + `\nEncryption done!`);
      
      // Test decryption
      const decrypted = await Kyber.decrypt(encrypted.ciphertext, keyPair.secretKey);
      
      // Check if secrets match
      const match = encrypted.sharedSecret === decrypted.sharedSecret;
      setResult(prev => prev + `\nSecrets match: ${match ? '✅' : '❌'}`);
      
    } catch (error) {
      setResult(`Error: ${error.message}`);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={testKyber}>
        <Text style={styles.buttonText}>Test Kyber</Text>
      </TouchableOpacity>
      <Text style={styles.result}>{result}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 20 },
  button: { backgroundColor: '#007AFF', padding: 15, borderRadius: 8, marginBottom: 20 },
  buttonText: { color: 'white', textAlign: 'center', fontSize: 18 },
  result: { fontSize: 16, textAlign: 'center' },
});

export default TestSimple;
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
- ✅ Hello message from native module
- ✅ Key pair generation with proper lengths
- ✅ Encryption producing ciphertext and shared secret
- ✅ Decryption recovering the same shared secret
- ✅ All shared secrets matching between encrypt/decrypt

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