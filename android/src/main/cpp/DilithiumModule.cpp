#include <jni.h>
#include <string>
#include <android/log.h>

// Include Dilithium headers
extern "C" {
    #include "../jni/dilithium-c/api.h"
}

#define LOG_TAG "ReactNativeDilithium"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

extern "C" {

JNIEXPORT jstring JNICALL
Java_com_reactnativekyber_DilithiumModule_sayHello(JNIEnv *env, jobject thiz) {
    return env->NewStringUTF("Hello from Dilithium!");
}

JNIEXPORT jobjectArray JNICALL
Java_com_reactnativekyber_DilithiumModule_dilithiumGenerateKeypair(JNIEnv *env, jobject thiz) {
    uint8_t pk[pqcrystals_dilithium3_ref_PUBLICKEYBYTES];
    uint8_t sk[pqcrystals_dilithium3_ref_SECRETKEYBYTES];
    
    int result = pqcrystals_dilithium3_ref_keypair(pk, sk);
    
    if (result != 0) {
        LOGE("Dilithium keypair generation failed");
        return nullptr;
    }
    
    // Create byte array for public key
    jbyteArray publicKeyArray = env->NewByteArray(pqcrystals_dilithium3_ref_PUBLICKEYBYTES);
    env->SetByteArrayRegion(publicKeyArray, 0, pqcrystals_dilithium3_ref_PUBLICKEYBYTES, (jbyte*)pk);
    
    // Create byte array for secret key
    jbyteArray secretKeyArray = env->NewByteArray(pqcrystals_dilithium3_ref_SECRETKEYBYTES);
    env->SetByteArrayRegion(secretKeyArray, 0, pqcrystals_dilithium3_ref_SECRETKEYBYTES, (jbyte*)sk);
    
    // Create return array
    jobjectArray resultArray = env->NewObjectArray(2, env->GetObjectClass(publicKeyArray), nullptr);
    env->SetObjectArrayElement(resultArray, 0, publicKeyArray);
    env->SetObjectArrayElement(resultArray, 1, secretKeyArray);
    
    return resultArray;
}

JNIEXPORT jbyteArray JNICALL
Java_com_reactnativekyber_DilithiumModule_dilithiumSign(JNIEnv *env, jobject thiz, 
                                                        jbyteArray message, jbyteArray secretKey) {
    jsize messageLen = env->GetArrayLength(message);
    jsize secretKeyLen = env->GetArrayLength(secretKey);
    
    if (secretKeyLen != pqcrystals_dilithium3_ref_SECRETKEYBYTES) {
        LOGE("Invalid secret key length: %d", secretKeyLen);
        return nullptr;
    }
    
    uint8_t *messageData = (uint8_t*)env->GetByteArrayElements(message, nullptr);
    uint8_t *sk = (uint8_t*)env->GetByteArrayElements(secretKey, nullptr);
    
    uint8_t sig[pqcrystals_dilithium3_ref_BYTES];
    size_t siglen;
    
    // Use empty context for signing (ctx = nullptr, ctxlen = 0)
    int result = pqcrystals_dilithium3_ref_signature(sig, &siglen, messageData, messageLen, nullptr, 0, sk);
    
    env->ReleaseByteArrayElements(message, (jbyte*)messageData, JNI_ABORT);
    env->ReleaseByteArrayElements(secretKey, (jbyte*)sk, JNI_ABORT);
    
    if (result != 0) {
        LOGE("Dilithium signing failed");
        return nullptr;
    }
    
    jbyteArray signatureArray = env->NewByteArray(siglen);
    env->SetByteArrayRegion(signatureArray, 0, siglen, (jbyte*)sig);
    
    return signatureArray;
}

JNIEXPORT jboolean JNICALL
Java_com_reactnativekyber_DilithiumModule_dilithiumVerify(JNIEnv *env, jobject thiz,
                                                          jbyteArray message, jbyteArray signature, jbyteArray publicKey) {
    jsize messageLen = env->GetArrayLength(message);
    jsize signatureLen = env->GetArrayLength(signature);
    jsize publicKeyLen = env->GetArrayLength(publicKey);
    
    if (publicKeyLen != pqcrystals_dilithium3_ref_PUBLICKEYBYTES) {
        LOGE("Invalid public key length: %d", publicKeyLen);
        return JNI_FALSE;
    }
    
    uint8_t *messageData = (uint8_t*)env->GetByteArrayElements(message, nullptr);
    uint8_t *sig = (uint8_t*)env->GetByteArrayElements(signature, nullptr);
    uint8_t *pk = (uint8_t*)env->GetByteArrayElements(publicKey, nullptr);
    
    // Use empty context for verification (ctx = nullptr, ctxlen = 0)
    int result = pqcrystals_dilithium3_ref_verify(sig, signatureLen, messageData, messageLen, nullptr, 0, pk);
    
    env->ReleaseByteArrayElements(message, (jbyte*)messageData, JNI_ABORT);
    env->ReleaseByteArrayElements(signature, (jbyte*)sig, JNI_ABORT);
    env->ReleaseByteArrayElements(publicKey, (jbyte*)pk, JNI_ABORT);
    
    return (result == 0) ? JNI_TRUE : JNI_FALSE;
}

} // extern "C" 