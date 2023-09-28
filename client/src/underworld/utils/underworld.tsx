
export enum Dir {
  North = 0,
  East = 1,
  West = 2,
  South = 3,
  Over = 4,
  Under = 5
}

export enum TileType {
  Void = 0x00,
  Entry = 0x01,
  Exit = 0x02,
  LockedExit = 0x03,
  Gem = 0x04,
  HatchClosed = 0x05,
  HatchDown = 0x06,
  HatchUp = 0x07,
  Empty = 0xfe,
  Path = 0xff,
}
