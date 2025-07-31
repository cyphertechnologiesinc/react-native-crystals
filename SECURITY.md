# Security Policy

## Reporting a Vulnerability

The React Native Kyber & Dilithium team takes security vulnerabilities seriously. We appreciate your efforts to responsibly disclose your findings and will make every effort to acknowledge your contributions.

To report a security vulnerability, please email us at:

**security@cyphertechnologies.co**

Please include the following information in your report:

- Type of vulnerability
- Full path of source file(s) related to the vulnerability
- Location of the vulnerability within the file(s)
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability

## Response Timeline

We aim to respond to security vulnerability reports within 48 hours with an initial assessment. For critical vulnerabilities, we will prioritize immediate response and mitigation.

You can expect the following timeline:

- **Initial Response**: Within 48 hours
- **Confirmation**: Within 1 week
- **Fix Development**: Timeline will vary based on severity and complexity
- **Public Disclosure**: After a fix has been developed and deployed

## Security Update Policy

Security updates will be released as soon as possible after a vulnerability has been confirmed and a fix has been developed. We will notify users through:

1. GitHub Security Advisories
2. Release notes in the CHANGELOG.md
3. npm deprecation notices (if applicable)

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

Only the latest minor version of each major release will receive security updates.

## Best Practices for Users

As a cryptographic library, we recommend the following security best practices:

1. **Keep the library updated**: Always use the latest version of React Native Kyber & Dilithium.
2. **Secure key storage**: Never store secret keys in plain text. Use secure storage solutions like:
   - iOS: Keychain Services
   - Android: Android Keystore or EncryptedSharedPreferences
   - React Native: react-native-keychain

3. **Memory management**: While the library handles clearing sensitive data from memory, be mindful of how you handle cryptographic keys and secrets in your application code.

4. **Input validation**: Always validate inputs before passing them to cryptographic functions.

5. **Don't roll your own crypto**: Use the provided APIs as designed and avoid creating custom cryptographic implementations.

## Security Implementation Details

React Native Kyber & Dilithium implements the following security measures:

1. **Post-quantum cryptography**: The library implements CRYSTALS-Kyber and CRYSTALS-Dilithium, which are NIST-selected post-quantum cryptographic algorithms.

2. **Memory safety**: Sensitive cryptographic material is properly cleared from memory after use.

3. **Constant-time operations**: Where possible, operations are implemented to run in constant time to mitigate timing attacks.

4. **No external dependencies**: The cryptographic implementations rely only on the official reference code from the CRYSTALS team.

## Acknowledgments

We would like to thank all security researchers who have helped improve the security of React Native Kyber & Dilithium. Contributors who report valid security vulnerabilities will be acknowledged (with permission) in our security advisories.

## Disclosure Policy

We follow a coordinated disclosure process:

1. Reporter submits vulnerability details to security@cyphertechnologies.co
2. We acknowledge receipt and begin investigation
3. We develop and test a fix
4. We release the fix and notify users
5. We publicly disclose the vulnerability after users have had time to update

Public disclosure timing will be negotiated with the reporter based on severity and impact.