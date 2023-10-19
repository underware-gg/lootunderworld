
import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  overwrite: true,
  schema: "http://localhost:8080/graphql",
  documents: "src/**/*.graphql",
  generates: {
    'src/generated/graphql.ts': {
      plugins: ['typescript', 'typescript-operations', 'typescript-graphql-request'],
      config: {
        rawRequest: true
      },
    },
  }
};

export default config;
