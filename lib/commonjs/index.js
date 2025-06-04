"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _reactNative = require("react-native");
const LINKING_ERROR = `The package 'react-native-kyber' doesn't seem to be linked. Make sure: \n\n` + _reactNative.Platform.select({
  ios: "- Use Xcode 12.0 or newer for iOS development\n",
  default: ''
}) + '- NPM: npm uninstall react-native-kyber && npm install react-native-kyber\n' + '- Yarn: yarn remove react-native-kyber && yarn add react-native-kyber\n' + _reactNative.Platform.select({
  ios: "- Run 'cd ios && pod install'\n",
  default: ''
}) + '- Rebuild the app (\`npx react-native run-ios\` for iOS or \`npx react-native run-android\` for Android)\n';
const KyberModule = _reactNative.NativeModules.Kyber ? _reactNative.NativeModules.Kyber : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
var _default = exports.default = KyberModule;
//# sourceMappingURL=index.js.map