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
  usize: { input: any; output: any; }
};

export type Chamber = {
  __typename?: 'Chamber';
  entity?: Maybe<World__Entity>;
  level_number?: Maybe<Scalars['u16']['output']>;
  location_id?: Maybe<Scalars['u128']['output']>;
  room_id?: Maybe<Scalars['u16']['output']>;
  seed?: Maybe<Scalars['u256']['output']>;
  yonder?: Maybe<Scalars['u16']['output']>;
};

export type ChamberConnection = {
  __typename?: 'ChamberConnection';
  edges?: Maybe<Array<Maybe<ChamberEdge>>>;
  page_info: World__PageInfo;
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
  LevelNumber = 'LEVEL_NUMBER',
  LocationId = 'LOCATION_ID',
  RoomId = 'ROOM_ID',
  Seed = 'SEED',
  Yonder = 'YONDER'
}

export type ChamberWhereInput = {
  level_number?: InputMaybe<Scalars['u16']['input']>;
  level_numberEQ?: InputMaybe<Scalars['u16']['input']>;
  level_numberGT?: InputMaybe<Scalars['u16']['input']>;
  level_numberGTE?: InputMaybe<Scalars['u16']['input']>;
  level_numberLT?: InputMaybe<Scalars['u16']['input']>;
  level_numberLTE?: InputMaybe<Scalars['u16']['input']>;
  level_numberNEQ?: InputMaybe<Scalars['u16']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  room_id?: InputMaybe<Scalars['u16']['input']>;
  room_idEQ?: InputMaybe<Scalars['u16']['input']>;
  room_idGT?: InputMaybe<Scalars['u16']['input']>;
  room_idGTE?: InputMaybe<Scalars['u16']['input']>;
  room_idLT?: InputMaybe<Scalars['u16']['input']>;
  room_idLTE?: InputMaybe<Scalars['u16']['input']>;
  room_idNEQ?: InputMaybe<Scalars['u16']['input']>;
  seed?: InputMaybe<Scalars['u256']['input']>;
  seedEQ?: InputMaybe<Scalars['u256']['input']>;
  seedGT?: InputMaybe<Scalars['u256']['input']>;
  seedGTE?: InputMaybe<Scalars['u256']['input']>;
  seedLT?: InputMaybe<Scalars['u256']['input']>;
  seedLTE?: InputMaybe<Scalars['u256']['input']>;
  seedNEQ?: InputMaybe<Scalars['u256']['input']>;
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
  protected?: Maybe<Scalars['u256']['output']>;
  south?: Maybe<Scalars['u8']['output']>;
  under?: Maybe<Scalars['u8']['output']>;
  west?: Maybe<Scalars['u8']['output']>;
};

export type MapConnection = {
  __typename?: 'MapConnection';
  edges?: Maybe<Array<Maybe<MapEdge>>>;
  page_info: World__PageInfo;
  total_count: Scalars['Int']['output'];
};

export type MapData = {
  __typename?: 'MapData';
  chest?: Maybe<Scalars['u256']['output']>;
  dark_tar?: Maybe<Scalars['u256']['output']>;
  entity?: Maybe<World__Entity>;
  location_id?: Maybe<Scalars['u128']['output']>;
  monsters?: Maybe<Scalars['u256']['output']>;
  slender_duck?: Maybe<Scalars['u256']['output']>;
};

export type MapDataConnection = {
  __typename?: 'MapDataConnection';
  edges?: Maybe<Array<Maybe<MapDataEdge>>>;
  page_info: World__PageInfo;
  total_count: Scalars['Int']['output'];
};

export type MapDataEdge = {
  __typename?: 'MapDataEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<MapData>;
};

export type MapDataOrder = {
  direction: OrderDirection;
  field: MapDataOrderField;
};

export enum MapDataOrderField {
  Chest = 'CHEST',
  DarkTar = 'DARK_TAR',
  LocationId = 'LOCATION_ID',
  Monsters = 'MONSTERS',
  SlenderDuck = 'SLENDER_DUCK'
}

export type MapDataWhereInput = {
  chest?: InputMaybe<Scalars['u256']['input']>;
  chestEQ?: InputMaybe<Scalars['u256']['input']>;
  chestGT?: InputMaybe<Scalars['u256']['input']>;
  chestGTE?: InputMaybe<Scalars['u256']['input']>;
  chestLT?: InputMaybe<Scalars['u256']['input']>;
  chestLTE?: InputMaybe<Scalars['u256']['input']>;
  chestNEQ?: InputMaybe<Scalars['u256']['input']>;
  dark_tar?: InputMaybe<Scalars['u256']['input']>;
  dark_tarEQ?: InputMaybe<Scalars['u256']['input']>;
  dark_tarGT?: InputMaybe<Scalars['u256']['input']>;
  dark_tarGTE?: InputMaybe<Scalars['u256']['input']>;
  dark_tarLT?: InputMaybe<Scalars['u256']['input']>;
  dark_tarLTE?: InputMaybe<Scalars['u256']['input']>;
  dark_tarNEQ?: InputMaybe<Scalars['u256']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  monsters?: InputMaybe<Scalars['u256']['input']>;
  monstersEQ?: InputMaybe<Scalars['u256']['input']>;
  monstersGT?: InputMaybe<Scalars['u256']['input']>;
  monstersGTE?: InputMaybe<Scalars['u256']['input']>;
  monstersLT?: InputMaybe<Scalars['u256']['input']>;
  monstersLTE?: InputMaybe<Scalars['u256']['input']>;
  monstersNEQ?: InputMaybe<Scalars['u256']['input']>;
  slender_duck?: InputMaybe<Scalars['u256']['input']>;
  slender_duckEQ?: InputMaybe<Scalars['u256']['input']>;
  slender_duckGT?: InputMaybe<Scalars['u256']['input']>;
  slender_duckGTE?: InputMaybe<Scalars['u256']['input']>;
  slender_duckLT?: InputMaybe<Scalars['u256']['input']>;
  slender_duckLTE?: InputMaybe<Scalars['u256']['input']>;
  slender_duckNEQ?: InputMaybe<Scalars['u256']['input']>;
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
  Protected = 'PROTECTED',
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
  protected?: InputMaybe<Scalars['u256']['input']>;
  protectedEQ?: InputMaybe<Scalars['u256']['input']>;
  protectedGT?: InputMaybe<Scalars['u256']['input']>;
  protectedGTE?: InputMaybe<Scalars['u256']['input']>;
  protectedLT?: InputMaybe<Scalars['u256']['input']>;
  protectedLTE?: InputMaybe<Scalars['u256']['input']>;
  protectedNEQ?: InputMaybe<Scalars['u256']['input']>;
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

export type ModelUnion = Chamber | Map | MapData | Score | Tile;

export enum OrderDirection {
  Asc = 'ASC',
  Desc = 'DESC'
}

export type Score = {
  __typename?: 'Score';
  entity?: Maybe<World__Entity>;
  key_location_id?: Maybe<Scalars['u128']['output']>;
  key_player?: Maybe<Scalars['ContractAddress']['output']>;
  location_id?: Maybe<Scalars['u128']['output']>;
  moves?: Maybe<Scalars['usize']['output']>;
  player?: Maybe<Scalars['ContractAddress']['output']>;
};

export type ScoreConnection = {
  __typename?: 'ScoreConnection';
  edges?: Maybe<Array<Maybe<ScoreEdge>>>;
  page_info: World__PageInfo;
  total_count: Scalars['Int']['output'];
};

export type ScoreEdge = {
  __typename?: 'ScoreEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<Score>;
};

export type ScoreOrder = {
  direction: OrderDirection;
  field: ScoreOrderField;
};

export enum ScoreOrderField {
  KeyLocationId = 'KEY_LOCATION_ID',
  KeyPlayer = 'KEY_PLAYER',
  LocationId = 'LOCATION_ID',
  Moves = 'MOVES',
  Player = 'PLAYER'
}

export type ScoreWhereInput = {
  key_location_id?: InputMaybe<Scalars['u128']['input']>;
  key_location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  key_location_idGT?: InputMaybe<Scalars['u128']['input']>;
  key_location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  key_location_idLT?: InputMaybe<Scalars['u128']['input']>;
  key_location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  key_location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  key_player?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  key_playerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  location_id?: InputMaybe<Scalars['u128']['input']>;
  location_idEQ?: InputMaybe<Scalars['u128']['input']>;
  location_idGT?: InputMaybe<Scalars['u128']['input']>;
  location_idGTE?: InputMaybe<Scalars['u128']['input']>;
  location_idLT?: InputMaybe<Scalars['u128']['input']>;
  location_idLTE?: InputMaybe<Scalars['u128']['input']>;
  location_idNEQ?: InputMaybe<Scalars['u128']['input']>;
  moves?: InputMaybe<Scalars['usize']['input']>;
  movesEQ?: InputMaybe<Scalars['usize']['input']>;
  movesGT?: InputMaybe<Scalars['usize']['input']>;
  movesGTE?: InputMaybe<Scalars['usize']['input']>;
  movesLT?: InputMaybe<Scalars['usize']['input']>;
  movesLTE?: InputMaybe<Scalars['usize']['input']>;
  movesNEQ?: InputMaybe<Scalars['usize']['input']>;
  player?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  playerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
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
  page_info: World__PageInfo;
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
  models?: Maybe<Array<Maybe<ModelUnion>>>;
  updated_at?: Maybe<Scalars['DateTime']['output']>;
};

export type World__EntityConnection = {
  __typename?: 'World__EntityConnection';
  edges?: Maybe<Array<Maybe<World__EntityEdge>>>;
  page_info: World__PageInfo;
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
  page_info: World__PageInfo;
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
  page_info: World__PageInfo;
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
  page_info: World__PageInfo;
  total_count: Scalars['Int']['output'];
};

export type World__ModelEdge = {
  __typename?: 'World__ModelEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Model>;
};

export type World__PageInfo = {
  __typename?: 'World__PageInfo';
  end_cursor?: Maybe<Scalars['Cursor']['output']>;
  has_next_page?: Maybe<Scalars['Boolean']['output']>;
  has_previous_page?: Maybe<Scalars['Boolean']['output']>;
  start_cursor?: Maybe<Scalars['Cursor']['output']>;
};

export type World__Query = {
  __typename?: 'World__Query';
  chamberModels?: Maybe<ChamberConnection>;
  entities?: Maybe<World__EntityConnection>;
  entity: World__Entity;
  events?: Maybe<World__EventConnection>;
  mapModels?: Maybe<MapConnection>;
  mapdataModels?: Maybe<MapDataConnection>;
  metadatas?: Maybe<World__MetadataConnection>;
  model: World__Model;
  models?: Maybe<World__ModelConnection>;
  scoreModels?: Maybe<ScoreConnection>;
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


export type World__QueryMapdataModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<MapDataOrder>;
  where?: InputMaybe<MapDataWhereInput>;
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


export type World__QueryScoreModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ScoreOrder>;
  where?: InputMaybe<ScoreWhereInput>;
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
  eventEmitted: World__Event;
  modelRegistered: World__Model;
};


export type World__SubscriptionEntityUpdatedArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type World__SubscriptionEventEmittedArgs = {
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
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
  page_info: World__PageInfo;
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


export type GetChamberTilesQuery = { __typename?: 'World__Query', entities?: { __typename?: 'World__EntityConnection', edges?: Array<{ __typename?: 'World__EntityEdge', node?: { __typename?: 'World__Entity', keys?: Array<string | null> | null, id?: string | null, models?: Array<{ __typename: 'Chamber' } | { __typename: 'Map' } | { __typename: 'MapData' } | { __typename: 'Score' } | { __typename: 'Tile', location_id?: any | null, pos?: any | null, tile_type?: any | null } | null> | null } | null } | null> | null } | null };


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