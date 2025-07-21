#include <stdint.h>
#include <stddef.h>
#include <string.h>

// Include namespaced Dilithium headers
#include "dilithium_namespace.h"
#include "../dilithium-c/sign.h"
#include "../dilithium-c/packing.h"
#include "../dilithium-c/polyvec.h"
#include "../dilithium-c/poly.h"
#include "../dilithium-c/randombytesd.h"
#include "../dilithium-c/symmetric.h"
#include "../dilithium-c/fips202.h"

// Wrapper functions for Dilithium (using Dilithium3)
int dilithium_keypair_wrapper(uint8_t *pk, uint8_t *sk) {
    return pqcrystals_dilithium3_ref_keypair(pk, sk);
}

int dilithium_sign_wrapper(uint8_t *sig, size_t *siglen, const uint8_t *m, size_t mlen, const uint8_t *sk) {
    // Use empty context for simplicity
    const uint8_t *ctx = (const uint8_t*)"";
    size_t ctxlen = 0;
    return pqcrystals_dilithium3_ref_signature(sig, siglen, m, mlen, ctx, ctxlen, sk);
}

int dilithium_verify_wrapper(const uint8_t *sig, size_t siglen, const uint8_t *m, size_t mlen, const uint8_t *pk) {
    // Use empty context for simplicity
    const uint8_t *ctx = (const uint8_t*)"";
    size_t ctxlen = 0;
    return pqcrystals_dilithium3_ref_verify(sig, siglen, m, mlen, ctx, ctxlen, pk);
} 