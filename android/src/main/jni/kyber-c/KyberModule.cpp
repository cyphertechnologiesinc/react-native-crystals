#include <jni.h>
#include <string>
#include <android/log.h>

// The key part: declare the C function before using it
extern "C" {
    // This tells C++ that these functions follow C naming conventions
    #include "params.h"
    #include "kem.h"  // Include your kem.h header

    // Explicitly declare the functions if needed
    int pqcrystals_kyber768_ref_keypair(unsigned char *pk, unsigned char *sk);
    int pqcrystals_kyber768_ref_enc(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
    int pqcrystals_kyber768_ref_dec(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);
}

#define LOG_TAG "KyberNative"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
    // Simple test function
    JNIEXPORT jstring JNICALL
    Java_com_cypherchat_KyberModule_sayHello(JNIEnv *env, jobject thiz) {
        LOGD("KyberModule sayHello called");
        return env->NewStringUTF("Hello from Kyber Module!");
    }

    // Generate Keypair
    JNIEXPORT jobjectArray JNICALL
    Java_com_cypherchat_KyberModule_kyberGenerateKeypair(JNIEnv *env, jobject thiz) {
        LOGD("Starting Kyber key generation");
        unsigned char pk[KYBER_PUBLICKEYBYTES];
        unsigned char sk[KYBER_SECRETKEYBYTES];

        // Try using the direct function since that's what the linker found
        int ret = pqcrystals_kyber768_ref_keypair(pk, sk);
        LOGD("pqcrystals_kyber768_ref_keypair returned: %d", ret);

        jobjectArray result = env->NewObjectArray(2, env->FindClass("[B"), nullptr);

        jbyteArray jpk = env->NewByteArray(KYBER_PUBLICKEYBYTES);
        jbyteArray jsk = env->NewByteArray(KYBER_SECRETKEYBYTES);

        env->SetByteArrayRegion(jpk, 0, KYBER_PUBLICKEYBYTES, reinterpret_cast<jbyte*>(pk));
        env->SetByteArrayRegion(jsk, 0, KYBER_SECRETKEYBYTES, reinterpret_cast<jbyte*>(sk));

        env->SetObjectArrayElement(result, 0, jpk);
        env->SetObjectArrayElement(result, 1, jsk);

        LOGD("Key generation complete");
        return result;
    }

    // Encrypt function - generates ciphertext and shared secret from public key
    JNIEXPORT jobjectArray JNICALL
    Java_com_cypherchat_KyberModule_kyberEncrypt(JNIEnv *env, jobject thiz, jbyteArray jpk) {
        LOGD("Starting Kyber encryption");

        // Get public key from Java
        jsize pkLen = env->GetArrayLength(jpk);
        if (pkLen != KYBER_PUBLICKEYBYTES) {
            LOGD("Invalid public key length: %d, expected: %d", pkLen, KYBER_PUBLICKEYBYTES);
            return nullptr;
        }

        unsigned char pk[KYBER_PUBLICKEYBYTES];
        unsigned char ct[KYBER_CIPHERTEXTBYTES];
        unsigned char ss[KYBER_SSBYTES];

        // Copy the public key from Java byte array
        env->GetByteArrayRegion(jpk, 0, KYBER_PUBLICKEYBYTES, reinterpret_cast<jbyte*>(pk));

        // Perform encryption
        int ret = pqcrystals_kyber768_ref_enc(ct, ss, pk);
        LOGD("pqcrystals_kyber768_ref_enc returned: %d", ret);

        // Create return arrays
        jobjectArray result = env->NewObjectArray(2, env->FindClass("[B"), nullptr);

        jbyteArray jct = env->NewByteArray(KYBER_CIPHERTEXTBYTES);
        jbyteArray jss = env->NewByteArray(KYBER_SSBYTES);

        env->SetByteArrayRegion(jct, 0, KYBER_CIPHERTEXTBYTES, reinterpret_cast<jbyte*>(ct));
        env->SetByteArrayRegion(jss, 0, KYBER_SSBYTES, reinterpret_cast<jbyte*>(ss));

        env->SetObjectArrayElement(result, 0, jct);
        env->SetObjectArrayElement(result, 1, jss);

        LOGD("Encryption complete");
        return result;
    }

    // Decrypt function - recovers shared secret from ciphertext using secret key
    JNIEXPORT jbyteArray JNICALL
    Java_com_cypherchat_KyberModule_kyberDecrypt(JNIEnv *env, jobject thiz, jbyteArray jct, jbyteArray jsk) {
        LOGD("Starting Kyber decryption");

        // Get ciphertext and secret key from Java
        jsize ctLen = env->GetArrayLength(jct);
        jsize skLen = env->GetArrayLength(jsk);

        if (ctLen != KYBER_CIPHERTEXTBYTES || skLen != KYBER_SECRETKEYBYTES) {
            LOGD("Invalid lengths - ct: %d (expected %d), sk: %d (expected %d)", 
                 ctLen, KYBER_CIPHERTEXTBYTES, skLen, KYBER_SECRETKEYBYTES);
            return nullptr;
        }

        unsigned char ct[KYBER_CIPHERTEXTBYTES];
        unsigned char sk[KYBER_SECRETKEYBYTES];
        unsigned char ss[KYBER_SSBYTES];

        // Copy the ciphertext and secret key from Java byte arrays
        env->GetByteArrayRegion(jct, 0, KYBER_CIPHERTEXTBYTES, reinterpret_cast<jbyte*>(ct));
        env->GetByteArrayRegion(jsk, 0, KYBER_SECRETKEYBYTES, reinterpret_cast<jbyte*>(sk));

        // Perform decryption
        int ret = pqcrystals_kyber768_ref_dec(ss, ct, sk);
        LOGD("pqcrystals_kyber768_ref_dec returned: %d", ret);

        // Create return array
        jbyteArray jss = env->NewByteArray(KYBER_SSBYTES);
        env->SetByteArrayRegion(jss, 0, KYBER_SSBYTES, reinterpret_cast<jbyte*>(ss));

        LOGD("Decryption complete");
        return jss;
    }
}
