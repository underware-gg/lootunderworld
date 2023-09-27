import { useEffect, useMemo, useState } from "react";
import { GraphQLClient } from "graphql-request";
import { getSdk } from "../../generated/graphql";
import { useDojo } from "../../DojoContext";
import { setComponentFromEntity } from "../../utils/utils";
import { Components } from "@latticexyz/recs";

export enum FetchStatus {
  Idle = "idle",
  Loading = "loading",
  Success = "success",
  Error = "error",
}

const client = new GraphQLClient(import.meta.env.VITE_PUBLIC_TORII!);
const sdk = getSdk(client);

type DojoEntity = {
  __typename?: "Entity";
  keys?: (string | bigint | null)[] | null | undefined;
  components?: any | null[];
};

type getEntitiesQuery = {
  entities: {
    edges: {
      cursor: string;
      node: {
        entity: DojoEntity;
      };
    }[];
  };
};

export const useSyncWorld = (): { loading: boolean } => {
  // Added async since await is used inside
  const {
    setup: { components },
  } = useDojo();

  const [loading, setLoading] = useState(true);

  useMemo(() => {
    const syncData = async () => {
      try {
        for (const componentName of Object.keys(components)) {
          let shouldContinue = true; // Renamed from continue to avoid reserved keyword
          let component = (components as Components)[componentName];
          let fields = Object.keys(component.schema).join(",");
          let cursor: string | undefined;
          while (shouldContinue) {
            // Fixed the template literal syntax here
            console.log(`Sync [${componentName}]...`)
            const queryBuilder = `
              query SyncWorld {
                entities: ${componentName.toLowerCase()}Components(${cursor ? `after: "${cursor}"` : ""} first: 100) {
                  edges {
                    cursor
                    node {
                      entity {
                        keys
                        id
                        components {
                          ... on ${componentName} {
                            __typename
                            ${fields}
                          }
                        }
                      }
                    }
                  }
                }
              }`;
            // console.log(`queryBuilder [${queryBuilder}]...`)

            const { entities }: getEntitiesQuery = await client.request(queryBuilder); // Assumed queryBuilder should be passed here
            // console.log(`query entities:`, entities)

            if (entities.edges.length === 100) {
              cursor = entities.edges[entities.edges.length - 1].cursor;
            } else {
              shouldContinue = false;
            }

            entities.edges.forEach((edge) => {
              setComponentFromEntity(edge.node.entity, componentName, components);
            });
          }
        }
      } catch (error) {
        console.log({ syncError: error });
      } finally {
        setLoading(false);
      }
    };
    syncData();
  }, []);

  return {
    loading,
  };
};

