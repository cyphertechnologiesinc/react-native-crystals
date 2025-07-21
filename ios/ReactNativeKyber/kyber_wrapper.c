#include <stdint.h>
#include <stddef.h>
#include <string.h>

// Include namespaced Kyber headers
#include "kyber_namespace.h"
#include "../kyber-c/indcpa.h"
#include "../kyber-c/verify.h"
#include "../kyber-c/symmetric.h"
#include "../kyber-c/randombytes.h"

// Wrapper functions for Kyber
int kyber_keypair_wrapper(uint8_t *pk, uint8_t *sk) {
    return crypto_kem_keypair(pk, sk);
}

int kyber_enc_wrapper(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
    return crypto_kem_enc(ct, ss, pk);
}

int kyber_dec_wrapper(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
    return crypto_kem_dec(ss, ct, sk);
} 