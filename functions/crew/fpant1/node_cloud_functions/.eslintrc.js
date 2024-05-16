const path = require('path');

const tsconfigPaths = process.env.TS_CONFIG_PATHS ? process.env.TS_CONFIG_PATHS.split(',') : [
  "functions/crew/fpant1/node_cloud_functions/tsconfig.json",
  "functions/crew/fpant1/node_cloud_functions/tsconfig.dev.json",
];

module.exports = {
    root: true,
    env: {
        es6: true,
        node: true,
    },
    extends: [
        "eslint:recommended",
        "plugin:import/errors",
        "plugin:import/warnings",
        "plugin:import/typescript",
        "google",
        "plugin:@typescript-eslint/recommended",
    ],
    parser: "@typescript-eslint/parser",
    parserOptions: {
        project: tsconfigPaths,
        sourceType: "module",
    },
    ignorePatterns: [
        "/dist/**/*", // Ignore built files.
        ".eslintrc.js",
    ],
    plugins: ["@typescript-eslint", "import"],
    rules: {
        quotes: ["error", "double"],
        "import/no-unresolved": 0,
        indent: ["error", 2],
        "max-len": "off",
        "valid-jsdoc": "off",
        "@typescript-eslint/no-explicit-any": "off",
        "@typescript-eslint/ban-types": "off",
    },
};
