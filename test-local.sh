#!/bin/bash

echo "🧪 React Native Kyber - NPM Only Testing Script"
echo "==============================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Ensure we're using npm
export npm_config_package_manager=npm
unset npm_config_user_config

print_status "Forcing npm usage (no yarn)"

# Step 1: Build package
echo ""
echo "📦 Building package..."
npm run prepack && npm pack

TARBALL=$(ls react-native-kyber-*.tgz 2>/dev/null | head -n 1)
if [ -z "$TARBALL" ]; then
    print_error "No tarball found"
    exit 1
fi
print_status "Created: $TARBALL"

# Step 2: Create test project
echo ""
echo "🚀 Creating test project..."
cd ..
rm -rf KyberTestApp

# Create with npm, no yarn

npx @react-native-community/cli@latest init KyberTestApp

echo "🚀 done creation moving to install..."
cd KyberTestApp

npm install


print_status "Test project created with npm"

# Step 3: Install our package  This will walk you through creating a new React Native project
echo ""
echo "📥 Installing Kyber package..."
npm install ../react-native-kyber/$TARBALL
print_status "Package installed"

# Step 4: iOS setup
echo ""
echo "🍎 iOS setup..."
if [ -d "ios" ]; then
    cd ios && pod install && cd ..
    print_status "iOS pods installed"
else
    print_warning "No iOS directory found"
fi

# Step 5: Create test file
echo ""
echo "📝 Creating test..."
cat > KyberTest.js << 'EOF'
import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, ScrollView, SafeAreaView } from 'react-native';

let Kyber;
try {
  Kyber = require('react-native-kyber').default;
} catch (e) {
  console.log('Kyber import failed:', e);
}

export default function KyberTest() {
  const [log, setLog] = useState('Ready to test...\n');
  const [testing, setTesting] = useState(false);

  const addLog = (msg) => setLog(prev => prev + `${msg}\n`);

  const test = async () => {
    setTesting(true);
    setLog('Testing Kyber...\n');
    
    try {
      if (!Kyber) throw new Error('Kyber not imported');
      
      addLog('✅ Module loaded');
      
      const hello = await Kyber.hello();
      addLog(`✅ Hello: ${hello}`);
      
      const keys = await Kyber.generateKeyPair();
      addLog(`✅ Keys: pub=${keys.publicKey.length}, sec=${keys.secretKey.length}`);
      
      const enc = await Kyber.encrypt(keys.publicKey);
      addLog(`✅ Encrypted: ct=${enc.ciphertext.length}, ss=${enc.sharedSecret.length}`);
      
      const dec = await Kyber.decrypt(enc.ciphertext, keys.secretKey);
      addLog(`✅ Decrypted: ss=${dec.sharedSecret.length}`);
      
      const match = enc.sharedSecret === dec.sharedSecret;
      addLog(match ? '🎉 SUCCESS: Secrets match!' : '❌ FAIL: Secrets differ');
      
    } catch (error) {
      addLog(`❌ Error: ${error.message}`);
    }
    
    setTesting(false);
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>Kyber Test</Text>
      <TouchableOpacity 
        style={[styles.button, testing && styles.disabled]} 
        onPress={test} 
        disabled={testing}
      >
        <Text style={styles.buttonText}>
          {testing ? 'Testing...' : 'Test Kyber'}
        </Text>
      </TouchableOpacity>
      <ScrollView style={styles.log}>
        <Text style={styles.logText}>{log}</Text>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: '#f0f0f0' },
  title: { fontSize: 24, fontWeight: 'bold', textAlign: 'center', marginBottom: 20 },
  button: { backgroundColor: '#007AFF', padding: 15, borderRadius: 8, marginBottom: 20 },
  disabled: { backgroundColor: '#ccc' },
  buttonText: { color: 'white', textAlign: 'center', fontSize: 18, fontWeight: 'bold' },
  log: { flex: 1, backgroundColor: '#000', borderRadius: 8, padding: 10 },
  logText: { color: '#0f0', fontFamily: 'Courier', fontSize: 14 },
});
EOF

# Update App.js/tsx
if [ -f "App.tsx" ]; then
    echo "import KyberTest from './KyberTest'; export default KyberTest;" > App.tsx
else
    echo "import KyberTest from './KyberTest'; export default KyberTest;" > App.js
fi

print_status "Test component created"

# Final instructions
echo ""
echo "🎯 Ready to test!"
echo "=================="
print_status "Run: cd KyberTestApp"
print_warning "Android: npx react-native run-android"
print_warning "iOS: npx react-native run-ios"
echo ""
echo "📱 The app will show a 'Test Kyber' button"
echo "📍 Location: $(pwd)"