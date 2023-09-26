import { GraphQLClient } from 'graphql-request';
import { GraphQLClientRequestHeaders } from 'graphql-request/build/cjs/types';
import { print } from 'graphql'
import gql from 'graphql-tag';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  ContractAddress: { input: any; output: any; }
  Cursor: { input: any; output: any; }
  DateTime: { input: any; output: any; }
  felt252: { input: any; output: any; }
  u8: { input: any; output: any; }
  u16: { input: any; output: any; }
  u32: { input: any; output: any; }
  u128: { input: any; output: any; }
  u256: { input: any; output: any; }
};

export type Chamber = {
  __typename?: 'Chamber';
  domain_id?: Maybe<Scalars['u16']['output']>;
  entity?: Maybe<Entity>;
  location_id?: Maybe<Scalars['u128']['output']>;
  minter?: Maybe<Scalars['ContractAddress']['output']>;
  seed?: Maybe<Scalars['u256']['output']>;
  token_id?: Maybe<Scalars['u16']['output']>;
  yonder?: Maybe<Scalars['u16']['output']>;
};

export type ChamberConnection = {
  __typename?: 'ChamberConnection';
  edges?: Maybe<Array<Maybe<ChamberEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type ChamberEdge = {
  __typename?: 'ChamberEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Chamber>;
};

export type ChamberOrder = {
  direction: Direction;
  field: ChamberOrderOrderField;
};

export enum ChamberOrderOrderField {
  DomainId = 'DOMAIN_ID',
  LocationId = 'LOCATION_ID',
  Minter = 'MINTER',
  Seed = 'SEED',
  TokenId = 'TOKEN_ID',
  Yonder = 'YONDER'
}

export type ChamberWhereInput = {
  domain_id?: InputMaybe<Scalars['Int']['input']>;
  domain_idGT?: InputMaybe<Scalars['Int']['input']>;
  domain_idGTE?: InputMaybe<Scalars['Int']['input']>;
  domain_idLT?: InputMaybe<Scalars['Int']['input']>;
  domain_idLTE?: InputMaybe<Scalars['Int']['input']>;
  domain_idNEQ?: InputMaybe<Scalars['Int']['input']>;
  location_id?: InputMaybe<Scalars['String']['input']>;
  location_idGT?: InputMaybe<Scalars['String']['input']>;
  location_idGTE?: InputMaybe<Scalars['String']['input']>;
  location_idLT?: InputMaybe<Scalars['String']['input']>;
  location_idLTE?: InputMaybe<Scalars['String']['input']>;
  location_idNEQ?: InputMaybe<Scalars['String']['input']>;
  minter?: InputMaybe<Scalars['String']['input']>;
  minterGT?: InputMaybe<Scalars['String']['input']>;
  minterGTE?: InputMaybe<Scalars['String']['input']>;
  minterLT?: InputMaybe<Scalars['String']['input']>;
  minterLTE?: InputMaybe<Scalars['String']['input']>;
  minterNEQ?: InputMaybe<Scalars['String']['input']>;
  seed?: InputMaybe<Scalars['String']['input']>;
  seedGT?: InputMaybe<Scalars['String']['input']>;
  seedGTE?: InputMaybe<Scalars['String']['input']>;
  seedLT?: InputMaybe<Scalars['String']['input']>;
  seedLTE?: InputMaybe<Scalars['String']['input']>;
  seedNEQ?: InputMaybe<Scalars['String']['input']>;
  token_id?: InputMaybe<Scalars['Int']['input']>;
  token_idGT?: InputMaybe<Scalars['Int']['input']>;
  token_idGTE?: InputMaybe<Scalars['Int']['input']>;
  token_idLT?: InputMaybe<Scalars['Int']['input']>;
  token_idLTE?: InputMaybe<Scalars['Int']['input']>;
  token_idNEQ?: InputMaybe<Scalars['Int']['input']>;
  yonder?: InputMaybe<Scalars['Int']['input']>;
  yonderGT?: InputMaybe<Scalars['Int']['input']>;
  yonderGTE?: InputMaybe<Scalars['Int']['input']>;
  yonderLT?: InputMaybe<Scalars['Int']['input']>;
  yonderLTE?: InputMaybe<Scalars['Int']['input']>;
  yonderNEQ?: InputMaybe<Scalars['Int']['input']>;
};

export type Component = {
  __typename?: 'Component';
  classHash?: Maybe<Scalars['felt252']['output']>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  transactionHash?: Maybe<Scalars['felt252']['output']>;
};

export type ComponentConnection = {
  __typename?: 'ComponentConnection';
  edges?: Maybe<Array<Maybe<ComponentEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type ComponentEdge = {
  __typename?: 'ComponentEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Component>;
};

export type ComponentUnion = Chamber | Doors | Map | Moves | Position | Tile;

export enum Direction {
  Asc = 'ASC',
  Desc = 'DESC'
}

export type Doors = {
  __typename?: 'Doors';
  east?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<Entity>;
  location_id?: Maybe<Scalars['u128']['output']>;
  north?: Maybe<Scalars['u8']['output']>;
  over?: Maybe<Scalars['u8']['output']>;
  south?: Maybe<Scalars['u8']['output']>;
  under?: Maybe<Scalars['u8']['output']>;
  west?: Maybe<Scalars['u8']['output']>;
};

export type DoorsConnection = {
  __typename?: 'DoorsConnection';
  edges?: Maybe<Array<Maybe<DoorsEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type DoorsEdge = {
  __typename?: 'DoorsEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Doors>;
};

export type DoorsOrder = {
  direction: Direction;
  field: DoorsOrderOrderField;
};

export enum DoorsOrderOrderField {
  East = 'EAST',
  LocationId = 'LOCATION_ID',
  North = 'NORTH',
  Over = 'OVER',
  South = 'SOUTH',
  Under = 'UNDER',
  West = 'WEST'
}

export type DoorsWhereInput = {
  east?: InputMaybe<Scalars['Int']['input']>;
  eastGT?: InputMaybe<Scalars['Int']['input']>;
  eastGTE?: InputMaybe<Scalars['Int']['input']>;
  eastLT?: InputMaybe<Scalars['Int']['input']>;
  eastLTE?: InputMaybe<Scalars['Int']['input']>;
  eastNEQ?: InputMaybe<Scalars['Int']['input']>;
  location_id?: InputMaybe<Scalars['String']['input']>;
  location_idGT?: InputMaybe<Scalars['String']['input']>;
  location_idGTE?: InputMaybe<Scalars['String']['input']>;
  location_idLT?: InputMaybe<Scalars['String']['input']>;
  location_idLTE?: InputMaybe<Scalars['String']['input']>;
  location_idNEQ?: InputMaybe<Scalars['String']['input']>;
  north?: InputMaybe<Scalars['Int']['input']>;
  northGT?: InputMaybe<Scalars['Int']['input']>;
  northGTE?: InputMaybe<Scalars['Int']['input']>;
  northLT?: InputMaybe<Scalars['Int']['input']>;
  northLTE?: InputMaybe<Scalars['Int']['input']>;
  northNEQ?: InputMaybe<Scalars['Int']['input']>;
  over?: InputMaybe<Scalars['Int']['input']>;
  overGT?: InputMaybe<Scalars['Int']['input']>;
  overGTE?: InputMaybe<Scalars['Int']['input']>;
  overLT?: InputMaybe<Scalars['Int']['input']>;
  overLTE?: InputMaybe<Scalars['Int']['input']>;
  overNEQ?: InputMaybe<Scalars['Int']['input']>;
  south?: InputMaybe<Scalars['Int']['input']>;
  southGT?: InputMaybe<Scalars['Int']['input']>;
  southGTE?: InputMaybe<Scalars['Int']['input']>;
  southLT?: InputMaybe<Scalars['Int']['input']>;
  southLTE?: InputMaybe<Scalars['Int']['input']>;
  southNEQ?: InputMaybe<Scalars['Int']['input']>;
  under?: InputMaybe<Scalars['Int']['input']>;
  underGT?: InputMaybe<Scalars['Int']['input']>;
  underGTE?: InputMaybe<Scalars['Int']['input']>;
  underLT?: InputMaybe<Scalars['Int']['input']>;
  underLTE?: InputMaybe<Scalars['Int']['input']>;
  underNEQ?: InputMaybe<Scalars['Int']['input']>;
  west?: InputMaybe<Scalars['Int']['input']>;
  westGT?: InputMaybe<Scalars['Int']['input']>;
  westGTE?: InputMaybe<Scalars['Int']['input']>;
  westLT?: InputMaybe<Scalars['Int']['input']>;
  westLTE?: InputMaybe<Scalars['Int']['input']>;
  westNEQ?: InputMaybe<Scalars['Int']['input']>;
};

export type Entity = {
  __typename?: 'Entity';
  componentNames?: Maybe<Scalars['String']['output']>;
  components?: Maybe<Array<Maybe<ComponentUnion>>>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  updatedAt?: Maybe<Scalars['DateTime']['output']>;
};

export type EntityConnection = {
  __typename?: 'EntityConnection';
  edges?: Maybe<Array<Maybe<EntityEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type EntityEdge = {
  __typename?: 'EntityEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Entity>;
};

export type Event = {
  __typename?: 'Event';
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  data?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Scalars['String']['output']>;
  systemCall: SystemCall;
  systemCallId?: Maybe<Scalars['Int']['output']>;
};

export type EventConnection = {
  __typename?: 'EventConnection';
  edges?: Maybe<Array<Maybe<EventEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type EventEdge = {
  __typename?: 'EventEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Event>;
};

export type Map = {
  __typename?: 'Map';
  bitmap?: Maybe<Scalars['u256']['output']>;
  entity?: Maybe<Entity>;
  entity_id?: Maybe<Scalars['u128']['output']>;
  protected?: Maybe<Scalars['u256']['output']>;
};

export type MapConnection = {
  __typename?: 'MapConnection';
  edges?: Maybe<Array<Maybe<MapEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type MapEdge = {
  __typename?: 'MapEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Map>;
};

export type MapOrder = {
  direction: Direction;
  field: MapOrderOrderField;
};

export enum MapOrderOrderField {
  Bitmap = 'BITMAP',
  EntityId = 'ENTITY_ID',
  Protected = 'PROTECTED'
}

export type MapWhereInput = {
  bitmap?: InputMaybe<Scalars['String']['input']>;
  bitmapGT?: InputMaybe<Scalars['String']['input']>;
  bitmapGTE?: InputMaybe<Scalars['String']['input']>;
  bitmapLT?: InputMaybe<Scalars['String']['input']>;
  bitmapLTE?: InputMaybe<Scalars['String']['input']>;
  bitmapNEQ?: InputMaybe<Scalars['String']['input']>;
  entity_id?: InputMaybe<Scalars['String']['input']>;
  entity_idGT?: InputMaybe<Scalars['String']['input']>;
  entity_idGTE?: InputMaybe<Scalars['String']['input']>;
  entity_idLT?: InputMaybe<Scalars['String']['input']>;
  entity_idLTE?: InputMaybe<Scalars['String']['input']>;
  entity_idNEQ?: InputMaybe<Scalars['String']['input']>;
  protected?: InputMaybe<Scalars['String']['input']>;
  protectedGT?: InputMaybe<Scalars['String']['input']>;
  protectedGTE?: InputMaybe<Scalars['String']['input']>;
  protectedLT?: InputMaybe<Scalars['String']['input']>;
  protectedLTE?: InputMaybe<Scalars['String']['input']>;
  protectedNEQ?: InputMaybe<Scalars['String']['input']>;
};

export type Moves = {
  __typename?: 'Moves';
  entity?: Maybe<Entity>;
  player?: Maybe<Scalars['ContractAddress']['output']>;
  remaining?: Maybe<Scalars['u8']['output']>;
};

export type MovesConnection = {
  __typename?: 'MovesConnection';
  edges?: Maybe<Array<Maybe<MovesEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type MovesEdge = {
  __typename?: 'MovesEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Moves>;
};

export type MovesOrder = {
  direction: Direction;
  field: MovesOrderOrderField;
};

export enum MovesOrderOrderField {
  Player = 'PLAYER',
  Remaining = 'REMAINING'
}

export type MovesWhereInput = {
  player?: InputMaybe<Scalars['String']['input']>;
  playerGT?: InputMaybe<Scalars['String']['input']>;
  playerGTE?: InputMaybe<Scalars['String']['input']>;
  playerLT?: InputMaybe<Scalars['String']['input']>;
  playerLTE?: InputMaybe<Scalars['String']['input']>;
  playerNEQ?: InputMaybe<Scalars['String']['input']>;
  remaining?: InputMaybe<Scalars['Int']['input']>;
  remainingGT?: InputMaybe<Scalars['Int']['input']>;
  remainingGTE?: InputMaybe<Scalars['Int']['input']>;
  remainingLT?: InputMaybe<Scalars['Int']['input']>;
  remainingLTE?: InputMaybe<Scalars['Int']['input']>;
  remainingNEQ?: InputMaybe<Scalars['Int']['input']>;
};

export type Position = {
  __typename?: 'Position';
  entity?: Maybe<Entity>;
  player?: Maybe<Scalars['ContractAddress']['output']>;
  x?: Maybe<Scalars['u32']['output']>;
  y?: Maybe<Scalars['u32']['output']>;
};

export type PositionConnection = {
  __typename?: 'PositionConnection';
  edges?: Maybe<Array<Maybe<PositionEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type PositionEdge = {
  __typename?: 'PositionEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Position>;
};

export type PositionOrder = {
  direction: Direction;
  field: PositionOrderOrderField;
};

export enum PositionOrderOrderField {
  Player = 'PLAYER',
  X = 'X',
  Y = 'Y'
}

export type PositionWhereInput = {
  player?: InputMaybe<Scalars['String']['input']>;
  playerGT?: InputMaybe<Scalars['String']['input']>;
  playerGTE?: InputMaybe<Scalars['String']['input']>;
  playerLT?: InputMaybe<Scalars['String']['input']>;
  playerLTE?: InputMaybe<Scalars['String']['input']>;
  playerNEQ?: InputMaybe<Scalars['String']['input']>;
  x?: InputMaybe<Scalars['Int']['input']>;
  xGT?: InputMaybe<Scalars['Int']['input']>;
  xGTE?: InputMaybe<Scalars['Int']['input']>;
  xLT?: InputMaybe<Scalars['Int']['input']>;
  xLTE?: InputMaybe<Scalars['Int']['input']>;
  xNEQ?: InputMaybe<Scalars['Int']['input']>;
  y?: InputMaybe<Scalars['Int']['input']>;
  yGT?: InputMaybe<Scalars['Int']['input']>;
  yGTE?: InputMaybe<Scalars['Int']['input']>;
  yLT?: InputMaybe<Scalars['Int']['input']>;
  yLTE?: InputMaybe<Scalars['Int']['input']>;
  yNEQ?: InputMaybe<Scalars['Int']['input']>;
};

export type Query = {
  __typename?: 'Query';
  chamberComponents?: Maybe<ChamberConnection>;
  component: Component;
  components?: Maybe<ComponentConnection>;
  doorsComponents?: Maybe<DoorsConnection>;
  entities?: Maybe<EntityConnection>;
  entity: Entity;
  event: Event;
  events?: Maybe<EventConnection>;
  mapComponents?: Maybe<MapConnection>;
  movesComponents?: Maybe<MovesConnection>;
  positionComponents?: Maybe<PositionConnection>;
  system: System;
  systemCall: SystemCall;
  systemCalls?: Maybe<SystemCallConnection>;
  systems?: Maybe<SystemConnection>;
  tileComponents?: Maybe<TileConnection>;
};


export type QueryChamberComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ChamberOrder>;
  where?: InputMaybe<ChamberWhereInput>;
};


export type QueryComponentArgs = {
  id: Scalars['ID']['input'];
};


export type QueryDoorsComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<DoorsOrder>;
  where?: InputMaybe<DoorsWhereInput>;
};


export type QueryEntitiesArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
};


export type QueryEntityArgs = {
  id: Scalars['ID']['input'];
};


export type QueryEventArgs = {
  id: Scalars['ID']['input'];
};


export type QueryMapComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<MapOrder>;
  where?: InputMaybe<MapWhereInput>;
};


export type QueryMovesComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<MovesOrder>;
  where?: InputMaybe<MovesWhereInput>;
};


export type QueryPositionComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PositionOrder>;
  where?: InputMaybe<PositionWhereInput>;
};


export type QuerySystemArgs = {
  id: Scalars['ID']['input'];
};


export type QuerySystemCallArgs = {
  id: Scalars['Int']['input'];
};


export type QueryTileComponentsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<TileOrder>;
  where?: InputMaybe<TileWhereInput>;
};

export type Subscription = {
  __typename?: 'Subscription';
  componentRegistered: Component;
  entityUpdated: Entity;
};

export type System = {
  __typename?: 'System';
  classHash?: Maybe<Scalars['felt252']['output']>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  systemCalls: Array<SystemCall>;
  transactionHash?: Maybe<Scalars['felt252']['output']>;
};

export type SystemCall = {
  __typename?: 'SystemCall';
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  data?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  system: System;
  systemId?: Maybe<Scalars['ID']['output']>;
  transactionHash?: Maybe<Scalars['String']['output']>;
};

export type SystemCallConnection = {
  __typename?: 'SystemCallConnection';
  edges?: Maybe<Array<Maybe<SystemCallEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type SystemCallEdge = {
  __typename?: 'SystemCallEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<SystemCall>;
};

export type SystemConnection = {
  __typename?: 'SystemConnection';
  edges?: Maybe<Array<Maybe<SystemEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type SystemEdge = {
  __typename?: 'SystemEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<System>;
};

export type Tile = {
  __typename?: 'Tile';
  entity?: Maybe<Entity>;
  key_location_id?: Maybe<Scalars['u128']['output']>;
  key_pos?: Maybe<Scalars['u8']['output']>;
  location_id?: Maybe<Scalars['u128']['output']>;
  pos?: Maybe<Scalars['u8']['output']>;
  tile_type?: Maybe<Scalars['u8']['output']>;
};

export type TileConnection = {
  __typename?: 'TileConnection';
  edges?: Maybe<Array<Maybe<TileEdge>>>;
  totalCount: Scalars['Int']['output'];
};

export type TileEdge = {
  __typename?: 'TileEdge';
  cursor: Scalars['Cursor']['output'];
  node?: Maybe<Tile>;
};

export type TileOrder = {
  direction: Direction;
  field: TileOrderOrderField;
};

export enum TileOrderOrderField {
  KeyLocationId = 'KEY_LOCATION_ID',
  KeyPos = 'KEY_POS',
  LocationId = 'LOCATION_ID',
  Pos = 'POS',
  TileType = 'TILE_TYPE'
}

export type TileWhereInput = {
  key_location_id?: InputMaybe<Scalars['String']['input']>;
  key_location_idGT?: InputMaybe<Scalars['String']['input']>;
  key_location_idGTE?: InputMaybe<Scalars['String']['input']>;
  key_location_idLT?: InputMaybe<Scalars['String']['input']>;
  key_location_idLTE?: InputMaybe<Scalars['String']['input']>;
  key_location_idNEQ?: InputMaybe<Scalars['String']['input']>;
  key_pos?: InputMaybe<Scalars['Int']['input']>;
  key_posGT?: InputMaybe<Scalars['Int']['input']>;
  key_posGTE?: InputMaybe<Scalars['Int']['input']>;
  key_posLT?: InputMaybe<Scalars['Int']['input']>;
  key_posLTE?: InputMaybe<Scalars['Int']['input']>;
  key_posNEQ?: InputMaybe<Scalars['Int']['input']>;
  location_id?: InputMaybe<Scalars['String']['input']>;
  location_idGT?: InputMaybe<Scalars['String']['input']>;
  location_idGTE?: InputMaybe<Scalars['String']['input']>;
  location_idLT?: InputMaybe<Scalars['String']['input']>;
  location_idLTE?: InputMaybe<Scalars['String']['input']>;
  location_idNEQ?: InputMaybe<Scalars['String']['input']>;
  pos?: InputMaybe<Scalars['Int']['input']>;
  posGT?: InputMaybe<Scalars['Int']['input']>;
  posGTE?: InputMaybe<Scalars['Int']['input']>;
  posLT?: InputMaybe<Scalars['Int']['input']>;
  posLTE?: InputMaybe<Scalars['Int']['input']>;
  posNEQ?: InputMaybe<Scalars['Int']['input']>;
  tile_type?: InputMaybe<Scalars['Int']['input']>;
  tile_typeGT?: InputMaybe<Scalars['Int']['input']>;
  tile_typeGTE?: InputMaybe<Scalars['Int']['input']>;
  tile_typeLT?: InputMaybe<Scalars['Int']['input']>;
  tile_typeLTE?: InputMaybe<Scalars['Int']['input']>;
  tile_typeNEQ?: InputMaybe<Scalars['Int']['input']>;
};

export type GetEntitiesQueryVariables = Exact<{ [key: string]: never; }>;


export type GetEntitiesQuery = { __typename?: 'Query', entities?: { __typename?: 'EntityConnection', edges?: Array<{ __typename?: 'EntityEdge', node?: { __typename?: 'Entity', keys?: Array<string | null> | null, components?: Array<{ __typename: 'Chamber' } | { __typename: 'Doors' } | { __typename: 'Map' } | { __typename: 'Moves', remaining?: any | null } | { __typename: 'Position', x?: any | null, y?: any | null } | { __typename: 'Tile' } | null> | null } | null } | null> | null } | null };


export const GetEntitiesDocument = gql`
    query getEntities {
  entities(keys: ["%"]) {
    edges {
      node {
        keys
        components {
          __typename
          ... on Moves {
            remaining
          }
          ... on Position {
            x
            y
          }
        }
      }
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType) => action();
const GetEntitiesDocumentString = print(GetEntitiesDocument);
export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getEntities(variables?: GetEntitiesQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<{ data: GetEntitiesQuery; extensions?: any; headers: Dom.Headers; status: number; }> {
        return withWrapper((wrappedRequestHeaders) => client.rawRequest<GetEntitiesQuery>(GetEntitiesDocumentString, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getEntities', 'query');
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;