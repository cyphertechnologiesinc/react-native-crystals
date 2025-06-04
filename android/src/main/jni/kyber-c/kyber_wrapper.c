#include "kem.h"
#include "indcpa.h"
#include "polyvec.h"
// Simple wrapper to expose a clean C API to RN
void kyber_generate_keypair(unsigned char *pk, unsigned char *sk) {
    crypto_kem_keypair(pk, sk);
}

void kyber_encrypt(unsigned char *ct, unsigned char *ss, const unsigned char *pk) {
    crypto_kem_enc(ct, ss, pk);
}

void kyber_decrypt(unsigned char *ss, const unsigned char *ct, const unsigned char *sk) {
    crypto_kem_dec(ss, ct, sk);
}
