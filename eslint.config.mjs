import eslint from '@eslint/js';
import importPlugin from 'eslint-plugin-import';
import jsdocPlugin from 'eslint-plugin-jsdoc';
import prettierPlugin from 'eslint-plugin-prettier';
import securityPlugin from 'eslint-plugin-security';
import simpleImportSort from 'eslint-plugin-simple-import-sort';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { ignores: ['dist', 'node_modules', 'coverage', 'prisma/migrations'] },

  // базовый ESLint
  eslint.configs.recommended,

  // TS с тип-проверкой
  ...tseslint.configs.recommendedTypeChecked,

  // JS-файлы (конфиги и т.п.)
  {
    files: ['**/*.js', '**/*.mjs', '**/*.cjs'],
    plugins: { prettier: prettierPlugin, 'simple-import-sort': simpleImportSort },
    languageOptions: { globals: { ...globals.node } },
    rules: {
      'no-console': 'warn',
      'no-debugger': 'error',
      'prettier/prettier': ['error', { endOfLine: 'auto' }],
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',
    },
  },

  // TS-файлы
  {
    files: ['**/*.ts', '**/*.tsx'],
    plugins: {
      prettier: prettierPlugin,
      import: importPlugin,
      'simple-import-sort': simpleImportSort,
      jsdoc: jsdocPlugin,
      security: securityPlugin,
    },
    languageOptions: {
      parserOptions: { projectService: true, tsconfigRootDir: import.meta.dirname },
      globals: { ...globals.node, ...globals.jest },
    },
    settings: {
      'import/resolver': {
        typescript: { alwaysTryTypes: true, project: ['./tsconfig.json', './tsconfig.build.json'] },
      },
    },
    rules: {
      'no-console': 'warn',
      'no-debugger': 'error',

      // TS
      '@typescript-eslint/no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/explicit-function-return-type': 'off',

      // Импорты
      'import/order': 'off',
      'import/no-unresolved': 'off',
      'simple-import-sort/imports': [
        'error',
        {
          groups: [
            ['^\\u0000'],
            ['^node:', '^@?\\w'],
            [
              '^@app(/.*)?$',
              '^@modules(/.*)?$',
              '^@shared(/.*)?$',
              '^@itak-dale(/.*)?$',
              '^@config(/.*)?$',
              '^@prisma(/.*)?$',
            ],
            ['^@/(.*)$', '^src/(.*)$'],
            ['^\\.\\.(?!/?$)', '^\\.\\./?$'],
            ['^\\./(?=.*/)', '^\\.(?!/?$)', '^\\./?$'],
            ['^.+\\.s?css$'],
          ],
        },
      ],
      'simple-import-sort/exports': 'error',

      // Prettier
      'prettier/prettier': ['error', { endOfLine: 'auto' }],

      // JSDoc
      'jsdoc/require-jsdoc': [
        'warn',
        {
          require: { FunctionDeclaration: true, MethodDefinition: false, ClassDeclaration: false },
        },
      ],

      // Security
      'security/detect-object-injection': 'off',
    },
  },
);
