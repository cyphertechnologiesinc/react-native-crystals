#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

typedef struct poly {
  int32_t coeffs[N];
} poly;

#define poly_reduce DILITHIUM_NAMESPACE(poly_reduce)
void poly_reduce(struct poly *a);
#define poly_caddq DILITHIUM_NAMESPACE(poly_caddq)
void poly_caddq(struct poly *a);

#define poly_add DILITHIUM_NAMESPACE(poly_add)
void poly_add(struct poly *c, const struct poly *a, const struct poly *b);
#define poly_sub DILITHIUM_NAMESPACE(poly_sub)
void poly_sub(struct poly *c, const struct poly *a, const struct poly *b);
#define poly_shiftl DILITHIUM_NAMESPACE(poly_shiftl)
void poly_shiftl(struct poly *a);

#define poly_ntt DILITHIUM_NAMESPACE(poly_ntt)
void poly_ntt(struct poly *a);
#define poly_invntt_tomont DILITHIUM_NAMESPACE(poly_invntt_tomont)
void poly_invntt_tomont(struct poly *a);
#define poly_pointwise_montgomery DILITHIUM_NAMESPACE(poly_pointwise_montgomery)
void poly_pointwise_montgomery(struct poly *c, const struct poly *a, const struct poly *b);

#define poly_power2round DILITHIUM_NAMESPACE(poly_power2round)
void poly_power2round(struct poly *a1, struct poly *a0, const struct poly *a);
#define poly_decompose DILITHIUM_NAMESPACE(poly_decompose)
void poly_decompose(struct poly *a1, struct poly *a0, const struct poly *a);
#define poly_make_hint DILITHIUM_NAMESPACE(poly_make_hint)
unsigned int poly_make_hint(struct poly *h, const struct poly *a0, const struct poly *a1);
#define poly_use_hint DILITHIUM_NAMESPACE(poly_use_hint)
void poly_use_hint(struct poly *b, const struct poly *a, const struct poly *h);

#define poly_chknorm DILITHIUM_NAMESPACE(poly_chknorm)
int poly_chknorm(const struct poly *a, int32_t B);
#define poly_uniform DILITHIUM_NAMESPACE(poly_uniform)
void poly_uniform(struct poly *a,
                  const uint8_t seed[SEEDBYTES],
                  uint16_t nonce);
#define poly_uniform_eta DILITHIUM_NAMESPACE(poly_uniform_eta)
void poly_uniform_eta(struct poly *a,
                      const uint8_t seed[CRHBYTES],
                      uint16_t nonce);
#define poly_uniform_gamma1 DILITHIUM_NAMESPACE(poly_uniform_gamma1)
void poly_uniform_gamma1(struct poly *a,
                         const uint8_t seed[CRHBYTES],
                         uint16_t nonce);
#define poly_challenge DILITHIUM_NAMESPACE(poly_challenge)
void poly_challenge(struct poly *c, const uint8_t seed[CTILDEBYTES]);

#define polyeta_pack DILITHIUM_NAMESPACE(polyeta_pack)
void polyeta_pack(uint8_t *r, const struct poly *a);
#define polyeta_unpack DILITHIUM_NAMESPACE(polyeta_unpack)
void polyeta_unpack(struct poly *r, const uint8_t *a);

#define polyt1_pack DILITHIUM_NAMESPACE(polyt1_pack)
void polyt1_pack(uint8_t *r, const struct poly *a);
#define polyt1_unpack DILITHIUM_NAMESPACE(polyt1_unpack)
void polyt1_unpack(struct poly *r, const uint8_t *a);

#define polyt0_pack DILITHIUM_NAMESPACE(polyt0_pack)
void polyt0_pack(uint8_t *r, const struct poly *a);
#define polyt0_unpack DILITHIUM_NAMESPACE(polyt0_unpack)
void polyt0_unpack(struct poly *r, const uint8_t *a);

#define polyz_pack DILITHIUM_NAMESPACE(polyz_pack)
void polyz_pack(uint8_t *r, const struct poly *a);
#define polyz_unpack DILITHIUM_NAMESPACE(polyz_unpack)
void polyz_unpack(struct poly *r, const uint8_t *a);

#define polyw1_pack DILITHIUM_NAMESPACE(polyw1_pack)
void polyw1_pack(uint8_t *r, const struct poly *a);

#endif
