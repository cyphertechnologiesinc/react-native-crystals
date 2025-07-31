# Changelog

All notable changes to the React Native Kyber & Dilithium project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2023-12-15

### Added
- Initial release of React Native Kyber & Dilithium
- Kyber768 implementation for post-quantum key exchange
- Dilithium3 implementation for post-quantum digital signatures
- Cross-platform support for iOS and Android
- TypeScript definitions and type safety
- Comprehensive documentation and examples
- Test suite for both Kyber and Dilithium implementations

### Security
- Implementation based on official CRYSTALS Kyber and Dilithium reference code
- Memory-safe operations with proper cleanup
- Constant-time operations where possible to mitigate timing attacks

## [Unreleased]

### Coming Soon
- Additional Kyber parameter sets (Kyber512, Kyber1024)
- Additional Dilithium parameter sets (Dilithium2, Dilithium5)
- Performance optimizations
- Additional helper utilities for common cryptographic workflows
- Expanded test coverage