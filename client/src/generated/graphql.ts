//@ts-nocheck
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
  entity?: Maybe<World__Entity>;
  location_id?: Maybe<Scalars['u128']['output']>;
  minter?: Maybe<Scalars['ContractAddress']['output']>;
  seed?: Maybe<Scalars['u256']['output']>;
  token_id?: Maybe<Scalars['u16']['output']>;
  yonder?: Maybe<Scalars['u16']['output']>;
};

export type ChamberConnection = {
  __typename?: 'ChamberConnection';
  edges?: Maybe<Array<Maybe<ChamberEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type ChamberEdge = {
  __typename?: 'ChamberEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Chamber>;
};

export type ChamberOrder = {
  direction: OrderDirection;
  field: ChamberOrderField;
};

export enum ChamberOrderField {
  DomainId = 'DOMAIN_ID',
  LocationId = 'LOCATION_ID',
  Minter = 'MINTER',
  Seed = 'SEED',
  TokenId = 'TOKEN_ID',
  Yonder = 'YONDER'
}

export type ChamberWhereInput = {
  domain_id?: InputMaybe<Scalars['u16']['input']>;
  domain_idEQ?: InputMaybe<Scalars['u16']['input']>;
  domain_idGT?: InputMaybe<Scalars['u16']['input']>;
  domain_idGTE?: InputMaybe<Scalars['u16']['input']>;
  domain_idLT?: InputMaybe<Scalars['u16']['input']>;
  domain_idLTE?: InputMaybe<Scalars['u16']['input']>;
  domain_idNEQ?: InputMaybe<Scalars['u16']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  minter?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  minterNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  seed?: InputMaybe<Scalars['u256']['input']>;
  seedEQ?: InputMaybe<Scalars['u256']['input']>;
  seedGT?: InputMaybe<Scalars['u256']['input']>;
  seedGTE?: InputMaybe<Scalars['u256']['input']>;
  seedLT?: InputMaybe<Scalars['u256']['input']>;
  seedLTE?: InputMaybe<Scalars['u256']['input']>;
  seedNEQ?: InputMaybe<Scalars['u256']['input']>;
  token_id?: InputMaybe<Scalars['u16']['input']>;
  token_idEQ?: InputMaybe<Scalars['u16']['input']>;
  token_idGT?: InputMaybe<Scalars['u16']['input']>;
  token_idGTE?: InputMaybe<Scalars['u16']['input']>;
  token_idLT?: InputMaybe<Scalars['u16']['input']>;
  token_idLTE?: InputMaybe<Scalars['u16']['input']>;
  token_idNEQ?: InputMaybe<Scalars['u16']['input']>;
  yonder?: InputMaybe<Scalars['u16']['input']>;
  yonderEQ?: InputMaybe<Scalars['u16']['input']>;
  yonderGT?: InputMaybe<Scalars['u16']['input']>;
  yonderGTE?: InputMaybe<Scalars['u16']['input']>;
  yonderLT?: InputMaybe<Scalars['u16']['input']>;
  yonderLTE?: InputMaybe<Scalars['u16']['input']>;
  yonderNEQ?: InputMaybe<Scalars['u16']['input']>;
};

export type Map = {
  __typename?: 'Map';
  bitmap?: Maybe<Scalars['u256']['output']>;
  east?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  entity_id?: Maybe<Scalars['u128']['output']>;
  generator_name?: Maybe<Scalars['felt252']['output']>;
  generator_value?: Maybe<Scalars['u32']['output']>;
  north?: Maybe<Scalars['u8']['output']>;
  over?: Maybe<Scalars['u8']['output']>;
  south?: Maybe<Scalars['u8']['output']>;
  under?: Maybe<Scalars['u8']['output']>;
  west?: Maybe<Scalars['u8']['output']>;
};

export type MapConnection = {
  __typename?: 'MapConnection';
  edges?: Maybe<Array<Maybe<MapEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type MapEdge = {
  __typename?: 'MapEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Map>;
};

export type MapOrder = {
  direction: OrderDirection;
  field: MapOrderField;
};

export enum MapOrderField {
  Bitmap = 'BITMAP',
  East = 'EAST',
  EntityId = 'ENTITY_ID',
  GeneratorName = 'GENERATOR_NAME',
  GeneratorValue = 'GENERATOR_VALUE',
  North = 'NORTH',
  Over = 'OVER',
  South = 'SOUTH',
  Under = 'UNDER',
  West = 'WEST'
}

export type MapWhereInput = {
  bitmap?: InputMaybe<Scalars['u256']['input']>;
  bitmapEQ?: InputMaybe<Scalars['u256']['input']>;
  bitmapGT?: InputMaybe<Scalars['u256']['input']>;
  bitmapGTE?: InputMaybe<Scalars['u256']['input']>;
  bitmapLT?: InputMaybe<Scalars['u256']['input']>;
  bitmapLTE?: InputMaybe<Scalars['u256']['input']>;
  bitmapNEQ?: InputMaybe<Scalars['u256']['input']>;
  east?: InputMaybe<Scalars['u8']['input']>;
  eastEQ?: InputMaybe<Scalars['u8']['input']>;
  eastGT?: InputMaybe<Scalars['u8']['input']>;
  eastGTE?: InputMaybe<Scalars['u8']['input']>;
  eastLT?: InputMaybe<Scalars['u8']['input']>;
  eastLTE?: InputMaybe<Scalars['u8']['input']>;
  eastNEQ?: InputMaybe<Scalars['u8']['input']>;
  entity_id?: InputMaybe<Scalars['u128']['input']>;
  entity_idEQ?: InputMaybe<Scalars['u128']['input']>;
  entity_idGT?: InputMaybe<Scalars['u128']['input']>;
  entity_idGTE?: InputMaybe<Scalars['u128']['input']>;
  entity_idLT?: InputMaybe<Scalars['u128']['input']>;
  entity_idLTE?: InputMaybe<Scalars['u128']['input']>;
  entity_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  generator_name?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameEQ?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameGT?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameGTE?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameLT?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameLTE?: InputMaybe<Scalars['felt252']['input']>;
  generator_nameNEQ?: InputMaybe<Scalars['felt252']['input']>;
  generator_value?: InputMaybe<Scalars['u32']['input']>;
  generator_valueEQ?: InputMaybe<Scalars['u32']['input']>;
  generator_valueGT?: InputMaybe<Scalars['u32']['input']>;
  generator_valueGTE?: InputMaybe<Scalars['u32']['input']>;
  generator_valueLT?: InputMaybe<Scalars['u32']['input']>;
  generator_valueLTE?: InputMaybe<Scalars['u32']['input']>;
  generator_valueNEQ?: InputMaybe<Scalars['u32']['input']>;
  north?: InputMaybe<Scalars['u8']['input']>;
  northEQ?: InputMaybe<Scalars['u8']['input']>;
  northGT?: InputMaybe<Scalars['u8']['input']>;
  northGTE?: InputMaybe<Scalars['u8']['input']>;
  northLT?: InputMaybe<Scalars['u8']['input']>;
  northLTE?: InputMaybe<Scalars['u8']['input']>;
  northNEQ?: InputMaybe<Scalars['u8']['input']>;
  over?: InputMaybe<Scalars['u8']['input']>;
  overEQ?: InputMaybe<Scalars['u8']['input']>;
  overGT?: InputMaybe<Scalars['u8']['input']>;
  overGTE?: InputMaybe<Scalars['u8']['input']>;
  overLT?: InputMaybe<Scalars['u8']['input']>;
  overLTE?: InputMaybe<Scalars['u8']['input']>;
  overNEQ?: InputMaybe<Scalars['u8']['input']>;
  south?: InputMaybe<Scalars['u8']['input']>;
  southEQ?: InputMaybe<Scalars['u8']['input']>;
  southGT?: InputMaybe<Scalars['u8']['input']>;
  southGTE?: InputMaybe<Scalars['u8']['input']>;
  southLT?: InputMaybe<Scalars['u8']['input']>;
  southLTE?: InputMaybe<Scalars['u8']['input']>;
  southNEQ?: InputMaybe<Scalars['u8']['input']>;
  under?: InputMaybe<Scalars['u8']['input']>;
  underEQ?: InputMaybe<Scalars['u8']['input']>;
  underGT?: InputMaybe<Scalars['u8']['input']>;
  underGTE?: InputMaybe<Scalars['u8']['input']>;
  underLT?: InputMaybe<Scalars['u8']['input']>;
  underLTE?: InputMaybe<Scalars['u8']['input']>;
  underNEQ?: InputMaybe<Scalars['u8']['input']>;
  west?: InputMaybe<Scalars['u8']['input']>;
  westEQ?: InputMaybe<Scalars['u8']['input']>;
  westGT?: InputMaybe<Scalars['u8']['input']>;
  westGTE?: InputMaybe<Scalars['u8']['input']>;
  westLT?: InputMaybe<Scalars['u8']['input']>;
  westLTE?: InputMaybe<Scalars['u8']['input']>;
  westNEQ?: InputMaybe<Scalars['u8']['input']>;
};

export type ModelUnion = Chamber | Map | State | Tile;

export enum OrderDirection {
  Asc = 'ASC',
  Desc = 'DESC'
}

export type State = {
  __typename?: 'State';
  entity?: Maybe<World__Entity>;
  light?: Maybe<Scalars['u8']['output']>;
  location_id?: Maybe<Scalars['u128']['output']>;
  threat?: Maybe<Scalars['u8']['output']>;
  wealth?: Maybe<Scalars['u8']['output']>;
};

export type StateConnection = {
  __typename?: 'StateConnection';
  edges?: Maybe<Array<Maybe<StateEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type StateEdge = {
  __typename?: 'StateEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<State>;
};

export type StateOrder = {
  direction: OrderDirection;
  field: StateOrderField;
};

export enum StateOrderField {
  Light = 'LIGHT',
  LocationId = 'LOCATION_ID',
  Threat = 'THREAT',
  Wealth = 'WEALTH'
}

export type StateWhereInput = {
  light?: InputMaybe<Scalars['u8']['input']>;
  lightEQ?: InputMaybe<Scalars['u8']['input']>;
  lightGT?: InputMaybe<Scalars['u8']['input']>;
  lightGTE?: InputMaybe<Scalars['u8']['input']>;
  lightLT?: InputMaybe<Scalars['u8']['input']>;
  lightLTE?: InputMaybe<Scalars['u8']['input']>;
  lightNEQ?: InputMaybe<Scalars['u8']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  threat?: InputMaybe<Scalars['u8']['input']>;
  threatEQ?: InputMaybe<Scalars['u8']['input']>;
  threatGT?: InputMaybe<Scalars['u8']['input']>;
  threatGTE?: InputMaybe<Scalars['u8']['input']>;
  threatLT?: InputMaybe<Scalars['u8']['input']>;
  threatLTE?: InputMaybe<Scalars['u8']['input']>;
  threatNEQ?: InputMaybe<Scalars['u8']['input']>;
  wealth?: InputMaybe<Scalars['u8']['input']>;
  wealthEQ?: InputMaybe<Scalars['u8']['input']>;
  wealthGT?: InputMaybe<Scalars['u8']['input']>;
  wealthGTE?: InputMaybe<Scalars['u8']['input']>;
  wealthLT?: InputMaybe<Scalars['u8']['input']>;
  wealthLTE?: InputMaybe<Scalars['u8']['input']>;
  wealthNEQ?: InputMaybe<Scalars['u8']['input']>;
};

export type Tile = {
  __typename?: 'Tile';
  entity?: Maybe<World__Entity>;
  key_location_id?: Maybe<Scalars['u128']['output']>;
  key_pos?: Maybe<Scalars['u8']['output']>;
  location_id?: Maybe<Scalars['u128']['output']>;
  pos?: Maybe<Scalars['u8']['output']>;
  tile_type?: Maybe<Scalars['u8']['output']>;
};

export type TileConnection = {
  __typename?: 'TileConnection';
  edges?: Maybe<Array<Maybe<TileEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type TileEdge = {
  __typename?: 'TileEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Tile>;
};

export type TileOrder = {
  direction: OrderDirection;
  field: TileOrderField;
};

export enum TileOrderField {
  KeyLocationId = 'KEY_LOCATION_ID',
  KeyPos = 'KEY_POS',
  LocationId = 'LOCATION_ID',
  Pos = 'POS',
  TileType = 'TILE_TYPE'
}

export type TileWhereInput = {
  key_location_id?: InputMaybe<Scalars['u128']['input']>;
  key_location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  key_location_idGT?: InputMaybe<Scalars['u128']['input']>;
  key_location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  key_location_idLT?: InputMaybe<Scalars['u128']['input']>;
  key_location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  key_location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  key_pos?: InputMaybe<Scalars['u8']['input']>;
  key_posEQ?: InputMaybe<Scalars['u8']['input']>;
  key_posGT?: InputMaybe<Scalars['u8']['input']>;
  key_posGTE?: InputMaybe<Scalars['u8']['input']>;
  key_posLT?: InputMaybe<Scalars['u8']['input']>;
  key_posLTE?: InputMaybe<Scalars['u8']['input']>;
  key_posNEQ?: InputMaybe<Scalars['u8']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  pos?: InputMaybe<Scalars['u8']['input']>;
  posEQ?: InputMaybe<Scalars['u8']['input']>;
  posGT?: InputMaybe<Scalars['u8']['input']>;
  posGTE?: InputMaybe<Scalars['u8']['input']>;
  posLT?: InputMaybe<Scalars['u8']['input']>;
  posLTE?: InputMaybe<Scalars['u8']['input']>;
  posNEQ?: InputMaybe<Scalars['u8']['input']>;
  tile_type?: InputMaybe<Scalars['u8']['input']>;
  tile_typeEQ?: InputMaybe<Scalars['u8']['input']>;
  tile_typeGT?: InputMaybe<Scalars['u8']['input']>;
  tile_typeGTE?: InputMaybe<Scalars['u8']['input']>;
  tile_typeLT?: InputMaybe<Scalars['u8']['input']>;
  tile_typeLTE?: InputMaybe<Scalars['u8']['input']>;
  tile_typeNEQ?: InputMaybe<Scalars['u8']['input']>;
};

export type World__Content = {
  __typename?: 'World__Content';
  cover_uri?: Maybe<Scalars['String']['output']>;
  description?: Maybe<Scalars['String']['output']>;
  icon_uri?: Maybe<Scalars['String']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  socials?: Maybe<Array<Maybe<World__Social>>>;
  website?: Maybe<Scalars['String']['output']>;
};

export type World__Entity = {
  __typename?: 'World__Entity';
  created_at?: Maybe<Scalars['DateTime']['output']>;
  event_id?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  model_names?: Maybe<Scalars['String']['output']>;
  models?: Maybe<Array<Maybe<ModelUnion>>>;
  updated_at?: Maybe<Scalars['DateTime']['output']>;
};

export type World__EntityConnection = {
  __typename?: 'World__EntityConnection';
  edges?: Maybe<Array<Maybe<World__EntityEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__EntityEdge = {
  __typename?: 'World__EntityEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Entity>;
};

export type World__Event = {
  __typename?: 'World__Event';
  created_at?: Maybe<Scalars['DateTime']['output']>;
  data?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  transaction_hash?: Maybe<Scalars['String']['output']>;
};

export type World__EventConnection = {
  __typename?: 'World__EventConnection';
  edges?: Maybe<Array<Maybe<World__EventEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__EventEdge = {
  __typename?: 'World__EventEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Event>;
};

export type World__Metadata = {
  __typename?: 'World__Metadata';
  content?: Maybe<World__Content>;
  cover_img?: Maybe<Scalars['String']['output']>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  icon_img?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  updated_at?: Maybe<Scalars['DateTime']['output']>;
  uri?: Maybe<Scalars['String']['output']>;
};

export type World__MetadataConnection = {
  __typename?: 'World__MetadataConnection';
  edges?: Maybe<Array<Maybe<World__MetadataEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__MetadataEdge = {
  __typename?: 'World__MetadataEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Metadata>;
};

export type World__Model = {
  __typename?: 'World__Model';
  class_hash?: Maybe<Scalars['felt252']['output']>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  transaction_hash?: Maybe<Scalars['felt252']['output']>;
};

export type World__ModelConnection = {
  __typename?: 'World__ModelConnection';
  edges?: Maybe<Array<Maybe<World__ModelEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__ModelEdge = {
  __typename?: 'World__ModelEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Model>;
};

export type World__Query = {
  __typename?: 'World__Query';
  chamberModels?: Maybe<ChamberConnection>;
  entities?: Maybe<World__EntityConnection>;
  entity: World__Entity;
  events?: Maybe<World__EventConnection>;
  mapModels?: Maybe<MapConnection>;
  metadatas?: Maybe<World__MetadataConnection>;
  model: World__Model;
  models?: Maybe<World__ModelConnection>;
  stateModels?: Maybe<StateConnection>;
  tileModels?: Maybe<TileConnection>;
  transaction: World__Transaction;
  transactions?: Maybe<World__TransactionConnection>;
};


export type World__QueryChamberModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ChamberOrder>;
  where?: InputMaybe<ChamberWhereInput>;
};


export type World__QueryEntitiesArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryEntityArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryEventsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryMapModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<MapOrder>;
  where?: InputMaybe<MapWhereInput>;
};


export type World__QueryMetadatasArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryModelArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type World__QueryStateModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<StateOrder>;
  where?: InputMaybe<StateWhereInput>;
};


export type World__QueryTileModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<TileOrder>;
  where?: InputMaybe<TileWhereInput>;
};


export type World__QueryTransactionArgs = {
  id: Scalars['ID']['input'];
};


export type World__QueryTransactionsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type World__Social = {
  __typename?: 'World__Social';
  name?: Maybe<Scalars['String']['output']>;
  url?: Maybe<Scalars['String']['output']>;
};

export type World__Subscription = {
  __typename?: 'World__Subscription';
  entityUpdated: World__Entity;
  modelRegistered: World__Model;
};


export type World__SubscriptionEntityUpdatedArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type World__SubscriptionModelRegisteredArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};

export type World__Transaction = {
  __typename?: 'World__Transaction';
  calldata?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  created_at?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  max_fee?: Maybe<Scalars['felt252']['output']>;
  nonce?: Maybe<Scalars['felt252']['output']>;
  sender_address?: Maybe<Scalars['felt252']['output']>;
  signature?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  transaction_hash?: Maybe<Scalars['felt252']['output']>;
};

export type World__TransactionConnection = {
  __typename?: 'World__TransactionConnection';
  edges?: Maybe<Array<Maybe<World__TransactionEdge>>>;
  total_count: Scalars['Int']['output'];
};

export type World__TransactionEdge = {
  __typename?: 'World__TransactionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Transaction>;
};

export type GetChamberTilesQueryVariables = Exact<{
  locationId: Scalars['String']['input'];
}>;


export type GetChamberTilesQuery = { __typename?: 'World__Query', entities?: { __typename?: 'World__EntityConnection', edges?: Array<{ __typename?: 'World__EntityEdge', node?: { __typename?: 'World__Entity', keys?: Array<string | null> | null, id?: string | null, models?: Array<{ __typename: 'Chamber' } | { __typename: 'Map' } | { __typename: 'State' } | { __typename: 'Tile', location_id?: any | null, pos?: any | null, tile_type?: any | null } | null> | null } | null } | null> | null } | null };


export const GetChamberTilesDocument = gql`
    query getChamberTiles($locationId: String!) {
  entities(keys: [$locationId], first: 100) {
    edges {
      node {
        keys
        id
        models {
          __typename
          ... on Tile {
            location_id
            pos
            tile_type
          }
        }
      }
    }
  }
}
    `;

export type SdkFunctionWrapper = <T>(action: (requestHeaders?:Record<string, string>) => Promise<T>, operationName: string, operationType?: string) => Promise<T>;


const defaultWrapper: SdkFunctionWrapper = (action, _operationName, _operationType) => action();
const GetChamberTilesDocumentString = print(GetChamberTilesDocument);
export function getSdk(client: GraphQLClient, withWrapper: SdkFunctionWrapper = defaultWrapper) {
  return {
    getChamberTiles(variables: GetChamberTilesQueryVariables, requestHeaders?: GraphQLClientRequestHeaders): Promise<{ data: GetChamberTilesQuery; errors?: GraphQLError[]; extensions?: any; headers: Headers; status: number; }> {
        return withWrapper((wrappedRequestHeaders) => client.rawRequest<GetChamberTilesQuery>(GetChamberTilesDocumentString, variables, {...requestHeaders, ...wrappedRequestHeaders}), 'getChamberTiles', 'query');
    }
  };
}
export type Sdk = ReturnType<typeof getSdk>;