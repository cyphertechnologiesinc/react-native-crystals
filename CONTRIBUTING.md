# Contributing to React Native Kyber & Dilithium

Thank you for your interest in contributing to React Native Kyber & Dilithium! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment Setup](#development-environment-setup)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)
- [Security Vulnerabilities](#security-vulnerabilities)

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct. Please report unacceptable behavior to the project maintainers.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Add the original repository as a remote named "upstream"
4. Create a new branch for your contribution

```bash
git clone https://github.com/YOUR-USERNAME/react-native-crystals.git
cd react-native-crystals
git remote add upstream https://github.com/ORIGINAL-OWNER/react-native-crystals.git
git checkout -b feature/your-feature-name
```

## Development Environment Setup

### Prerequisites

- Node.js 16+
- React Native CLI
- iOS: Xcode 12.0+, CocoaPods
- Android: Android Studio, NDK

### Installation

1. Install dependencies:
```bash
npm install
```

2. Set up the example app:
```bash
npm run example
```

## Development Workflow

1. Make your changes in your feature branch
2. Run tests to ensure your changes don't break existing functionality:
```bash
npm test
```

3. Run the example app to test your changes:
```bash
# iOS
cd example && npx react-native run-ios

# Android
cd example && npx react-native run-android
```

4. Commit your changes with a clear commit message

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update the example app if necessary
3. Ensure all tests pass
4. Ensure your code follows the project's coding standards
5. Submit a pull request to the `main` branch
6. The maintainers will review your PR and may request changes
7. Once approved, your PR will be merged

## Coding Standards

- Follow the existing code style in the project
- Use TypeScript for type safety
- Document public APIs with JSDoc comments
- Keep code modular and maintainable
- Write clear, descriptive variable and function names
- Add comments for complex logic

## Testing

- Write tests for all new features and bug fixes
- Ensure all tests pass before submitting a PR
- Test on both iOS and Android platforms when applicable

## Reporting Bugs

When reporting bugs, please include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Environment details (OS, device, React Native version, etc.)

## Feature Requests

Feature requests are welcome. Please provide:

- A clear and descriptive title
- Detailed description of the proposed feature
- Any relevant examples or mockups
- Explanation of why this feature would be useful to most users

## Security Vulnerabilities

If you discover a security vulnerability, please do NOT open an issue. Email the project maintainers directly. Security issues will be addressed with the highest priority.

## License

By contributing to React Native Kyber & Dilithium, you agree that your contributions will be licensed under the project's MIT license.

Thank you for contributing to React Native Kyber & Dilithium!