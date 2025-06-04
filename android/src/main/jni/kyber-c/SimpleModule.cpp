#include <jni.h>
#include <string>
#include <android/log.h>

#define LOG_TAG "SimpleNative"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" {
    // Simple function that returns a string
    JNIEXPORT jstring JNICALL
    Java_com_cypherchat_SimpleModule_getGreeting(JNIEnv *env, jobject thiz) {
        LOGD("Native getGreeting called");
        return env->NewStringUTF("Hello from C++!");
    }

    // Simple function that takes a string parameter and returns a modified string
    JNIEXPORT jstring JNICALL
    Java_com_cypherchat_SimpleModule_echo(JNIEnv *env, jobject thiz, jstring input) {
        const char *inputStr = env->GetStringUTFChars(input, 0);
        LOGD("Native echo called with: %s", inputStr);

        // Create a new string with a prefix
        std::string result = "Echo: ";
        result += inputStr;

        // Release the string
        env->ReleaseStringUTFChars(input, inputStr);

        return env->NewStringUTF(result.c_str());
    }
}
