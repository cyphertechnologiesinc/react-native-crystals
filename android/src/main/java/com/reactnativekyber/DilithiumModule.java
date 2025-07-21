package com.reactnativekyber;

import com.facebook.react.bridge.*;
import android.util.Base64;
import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class DilithiumModule extends ReactContextBaseJavaModule {
    private static final String TAG = "ReactNativeDilithium";

    static {
        System.loadLibrary("reactnativekyber"); // Same library, different module
    }

    public DilithiumModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "Dilithium";
    }
    
    // Native method declarations - Dilithium3 only
    public native String sayHello();
    public native byte[][] dilithiumGenerateKeypair();
    public native byte[] dilithiumSign(byte[] message, byte[] secretKey);
    public native boolean dilithiumVerify(byte[] message, byte[] signature, byte[] publicKey);
    
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
            byte[][] keys = dilithiumGenerateKeypair();
            if (keys == null || keys.length != 2) {
                promise.reject("ERR_KEYGEN", "Failed to generate Dilithium keypair: null or invalid result");
                return;
            }
            
            WritableMap result = Arguments.createMap();
            result.putString("publicKey", Base64.encodeToString(keys[0], Base64.NO_WRAP));
            result.putString("secretKey", Base64.encodeToString(keys[1], Base64.NO_WRAP));
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(TAG, "Error generating Dilithium key pair", e);
            promise.reject("ERR_KEYGEN", "Failed to generate Dilithium keypair: " + e.getMessage(), e);
        }
    }
    
    @ReactMethod
    public void sign(String message, String secretKeyBase64, Promise promise) {
        try {
            byte[] messageBytes = message.getBytes("UTF-8");
            byte[] secretKey = Base64.decode(secretKeyBase64, Base64.DEFAULT);
            
            if (secretKey == null) {
                promise.reject("ERR_INVALID_KEY", "Invalid secret key format");
                return;
            }
            
            byte[] signature = dilithiumSign(messageBytes, secretKey);
            if (signature == null) {
                promise.reject("ERR_SIGN", "Signing failed: null result");
                return;
            }
            
            String signatureBase64 = Base64.encodeToString(signature, Base64.NO_WRAP);
            
            WritableMap returnValue = Arguments.createMap();
            returnValue.putString("signature", signatureBase64);
            
            promise.resolve(returnValue);
        } catch (Exception e) {
            Log.e(TAG, "Error signing with Dilithium", e);
            promise.reject("ERR_SIGN", "Failed to sign: " + e.getMessage(), e);
        }
    }
    
    @ReactMethod
    public void verify(String message, String signatureBase64, String publicKeyBase64, Promise promise) {
        try {
            byte[] messageBytes = message.getBytes("UTF-8");
            byte[] signature = Base64.decode(signatureBase64, Base64.DEFAULT);
            byte[] publicKey = Base64.decode(publicKeyBase64, Base64.DEFAULT);
            
            if (signature == null) {
                promise.reject("ERR_INVALID_SIGNATURE", "Invalid signature format");
                return;
            }
            
            if (publicKey == null) {
                promise.reject("ERR_INVALID_KEY", "Invalid public key format");
                return;
            }
            
            boolean isValid = dilithiumVerify(messageBytes, signature, publicKey);
            
            WritableMap returnValue = Arguments.createMap();
            returnValue.putBoolean("isValid", isValid);
            
            promise.resolve(returnValue);
        } catch (Exception e) {
            Log.e(TAG, "Error verifying Dilithium signature", e);
            promise.reject("ERR_VERIFY", "Failed to verify: " + e.getMessage(), e);
        }
    }
} 