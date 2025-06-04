package com.reactnativekyber;

import com.facebook.react.bridge.*;
import android.util.Base64;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class KyberModule extends ReactContextBaseJavaModule {
    private static final String TAG = "ReactNativeKyber";

    static {
        System.loadLibrary("reactnativekyber");
    }

    public KyberModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "Kyber";
    }
    
    // Native method declarations
    public native String sayHello();
    public native byte[][] kyberGenerateKeypair();
    public native byte[][] kyberEncrypt(byte[] publicKey);
    public native byte[] kyberDecrypt(byte[] ciphertext, byte[] secretKey);
    
    @ReactMethod
    public void hello(Promise promise) {
        try {
            String message = sayHello();
            promise.resolve(message);
        } catch (Exception e) {
            Log.e(TAG, "Error in hello", e);
            promise.reject("ERR", e.getMessage());
        }
    }
    
    @ReactMethod
    public void generateKeyPair(Promise promise) {
        try {
            byte[][] keys = kyberGenerateKeypair();
            WritableMap result = Arguments.createMap();
            result.putString("publicKey", Base64.encodeToString(keys[0], Base64.NO_WRAP));
            result.putString("secretKey", Base64.encodeToString(keys[1], Base64.NO_WRAP));
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(TAG, "Error generating key pair", e);
            promise.reject("ERR_KEYGEN", "Failed to generate keypair: " + e.getMessage(), e);
        }
    }
    
    @ReactMethod
    public void encrypt(String publicKeyBase64, Promise promise) {
        try {
            byte[] publicKey = Base64.decode(publicKeyBase64, Base64.DEFAULT);
            byte[][] result = kyberEncrypt(publicKey);
            
            String ciphertextBase64 = Base64.encodeToString(result[0], Base64.NO_WRAP);
            String sharedSecretBase64 = Base64.encodeToString(result[1], Base64.NO_WRAP);
            
            WritableMap returnValue = Arguments.createMap();
            returnValue.putString("ciphertext", ciphertextBase64);
            returnValue.putString("sharedSecret", sharedSecretBase64);
            
            promise.resolve(returnValue);
        } catch (Exception e) {
            Log.e(TAG, "Error encrypting", e);
            promise.reject("ERR_ENCRYPT", "Failed to encrypt: " + e.getMessage(), e);
        }
    }
    
    @ReactMethod
    public void decrypt(String ciphertextBase64, String secretKeyBase64, Promise promise) {
        try {
            byte[] ciphertext = Base64.decode(ciphertextBase64, Base64.DEFAULT);
            byte[] secretKey = Base64.decode(secretKeyBase64, Base64.DEFAULT);
            
            byte[] sharedSecret = kyberDecrypt(ciphertext, secretKey);
            String sharedSecretBase64 = Base64.encodeToString(sharedSecret, Base64.NO_WRAP);
            
            WritableMap returnValue = Arguments.createMap();
            returnValue.putString("sharedSecret", sharedSecretBase64);
            
            promise.resolve(returnValue);
        } catch (Exception e) {
            Log.e(TAG, "Error decrypting", e);
            promise.reject("ERR_DECRYPT", "Failed to decrypt: " + e.getMessage(), e);
        }
    }
}