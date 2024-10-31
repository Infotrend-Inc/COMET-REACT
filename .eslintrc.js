module.exports = {
    env: {
      browser: true,
      es2021: true,
      jest: true, 
    },
    extends: [
      "eslint:recommended",
      "plugin:react/recommended",
      "plugin:jest/recommended",
    ],
    parserOptions: {
      ecmaFeatures: {
        jsx: true,
      },
      ecmaVersion: 12,
      sourceType: "module",
    },
    settings: {
      react: {
        version: "detect", // Automatically detect the React version
      },
    },
    plugins: ["react", "jest"],
    rules: {
      "react/react-in-jsx-scope": "off", // Off for Next.js or React 17+
      "no-undef": "off", // Turn off for test files if you are using Jest globals
    },
  };
  