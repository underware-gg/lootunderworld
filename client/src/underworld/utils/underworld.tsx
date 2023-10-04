

//-----------------------------------
// From Crawler SDK
//

import { validate } from "graphql"

export enum Dir {
  North = 0,
  East = 1,
  West = 2,
  South = 3,
  Over = 4,
  Under = 5,
}

export const DirNames = {
  [Dir.North]: 'North',
  [Dir.East]: 'East',
  [Dir.West]: 'West',
  [Dir.South]: 'South',
  [Dir.Over]: 'Over',
  [Dir.Under]: 'Under',
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

export enum Domain {
  Realms = 1,
  // CryptsAndCaverns = 2,
}

export const DomainTokenCount = {
  [Domain.Realms]: 8000,
}

export interface Compass {
  domainId?: Domain
  tokenId?: number
  over?: number
  under?: number
  north?: number
  east?: number
  west?: number
  south?: number
}

export const validateCompass = (compass: Compass | null): boolean => {
  if (!compass) return false
  const hasNorth = (compass.north && compass.north > 0)
  const hasSouth = (compass.south && compass.south > 0)
  const hasEast = (compass.east && compass.east > 0)
  const hasWest = (compass.west && compass.west > 0)
  if ((hasNorth && hasSouth)
    || (!hasNorth && !hasSouth)
    || (hasEast && hasWest)
    || (!hasEast && !hasWest)
  ) return false
  if (compass.tokenId &&
    (compass.domainId == null || compass.tokenId < 1 || compass.tokenId > DomainTokenCount[compass.domainId])
  ) return false
  return true
}

export const validatedCompass = (compass: Compass | null): Compass | null => {
  if (!compass || !validateCompass(compass)) {
    return null
  }
  let result = { ...compass }
  if (!result.domainId) delete result.domainId
  if (!result.tokenId) delete result.tokenId
  if (!result.over) delete result.over
  if (!result.under) delete result.under
  if (!result.north) delete result.north
  if (!result.east) delete result.east
  if (!result.west) delete result.west
  if (!result.south) delete result.south
  return result
}

export const slugSeparators = [null, '', ',', '.', ';', '-'] as const
export const defaultSlugSeparator = ','
export type SlugSeparator = typeof slugSeparators[number]

export const compassToSlug = (compass: Compass | null, yonder: number = 0, separator: SlugSeparator = defaultSlugSeparator): string => {
  if (!compass || !validateCompass(compass)) return ''
  let result = ''
  if (compass.tokenId) {
    result += `#${compass.tokenId}`
    if (separator) result += separator
  }
  if (compass.over || compass.under) {
    if (compass.over && compass.over > 0) result += `O${compass.over}`
    if (compass.under && compass.under > 0) result += `U${compass.under}`
    if (separator) result += separator
  }
  if (compass.north && compass.north > 0) result += `N${compass.north}`
  if (compass.south && compass.south > 0) result += `S${compass.south}`
  if (separator) result += separator
  if (compass.east && compass.east > 0) result += `E${compass.east}`
  if (compass.west && compass.west > 0) result += `W${compass.west}`
  if (yonder) {
    if (separator) result += separator
    result += `Y${yonder}`
  }
  return result
}

export const compassToCoord = (compass: Compass | null): bigint => {
  let result = 0n
  if (compass && validateCompass(compass)) {
    if (compass.domainId && compass.domainId > 0) result += BigInt(compass.domainId) << 112n
    if (compass.tokenId && compass.tokenId > 0) result += BigInt(compass.tokenId) << 96n
    if (compass.over && compass.over > 0) result += BigInt(compass.over) << 80n
    if (compass.under && compass.under > 0) result += BigInt(compass.under) << 64n
    if (compass.north && compass.north > 0) result += BigInt(compass.north) << 48n
    if (compass.east && compass.east > 0) result += BigInt(compass.east) << 32n
    if (compass.west && compass.west > 0) result += BigInt(compass.west) << 16n
    if (compass.south && compass.south > 0) result += BigInt(compass.south)
  }
  return result
}

export const coordToCompass = (coord: bigint): Compass | null => {
  let result: Compass = {
    domainId: Number((coord >> 112n) & BigInt(0xffff)),
    tokenId: Number((coord >> 96n) & BigInt(0xffff)),
    over: Number((coord >> 80n) & BigInt(0xffff)),
    under: Number((coord >> 64n) & BigInt(0xffff)),
    north: Number((coord >> 48n) & BigInt(0xffff)),
    east: Number((coord >> 32n) & BigInt(0xffff)),
    west: Number((coord >> 16n) & BigInt(0xffff)),
    south: Number(coord & BigInt(0xffff)),
  }
  return validatedCompass(result)
}

export const coordToSlug = (coord: bigint, yonder: number = 0): string => {
  return compassToSlug(coordToCompass(coord), yonder)
}

export const offsetCompass = (compass: Compass | null, dir: Dir): Compass | null => {
  const _add = (v: number | undefined) => (v ? v + 1 : 1)
  const _sub = (v: number | undefined) => (v && v > 1 ? v - 1 : 0)
  if (!compass) return null
  let result = { ...compass }
  if (dir == Dir.North) {
    result.south = _sub(result.south)
    if (!result.south) result.north = _add(result.north)
  } else if (dir == Dir.South) {
    result.north = _sub(result.north)
    if (!result.north) result.south = _add(result.south)
  } else if (dir == Dir.East) {
    result.west = _sub(result.west)
    if (!result.west) result.east = _add(result.east)
  } else if (dir == Dir.West) {
    result.east = _sub(result.east)
    if (!result.east) result.west = _add(result.west)
  } else if (dir == Dir.Over) {
    result.under = _sub(result.under)
    if (!result.under) result.over = _add(result.over)
  } else if (dir == Dir.Under) {
    result.over = _sub(result.over)
    if (!result.over) result.under = _add(result.under)
  }
  return validatedCompass(result)
}

export const offsetCoord = (coord: bigint, dir: Dir): bigint => {
  return compassToCoord(offsetCompass(coordToCompass(coord), dir))
}

//-----------------------------------
// Move to Crawler SDK
//

export const makeRealmEntryChamberIdFromCoord = (realmId: number, coord: bigint): bigint => {
  let result = coordToCompass(coord)
  if (result) {
    result.domainId = Domain.Realms
    result.tokenId = realmId
    result.over = 0
    result.under = 1
  }
  return compassToCoord(result)
}

export const expandTilemap_1p = (tilemap: number[]) => {
  const gridSize = 18
  let result = Array(gridSize * gridSize).fill(tilemap.length > 0 ? TileType.Void : TileType.Path)
  const _set = (xx: number, yy: number, tileType: number) => { result[yy * gridSize + xx] = tileType }
  for (let i = 0; i < tilemap.length; ++i) {
    const tileType = tilemap[i]
    const x = i % 16
    const y = Math.floor(i / 16)
    let xx = x + 1
    let yy = y + 1
    if ([TileType.Entry, TileType.Exit, TileType.LockedExit].includes(tileType)) {
      if (x == 0) {
        _set(xx, yy, TileType.Path)
        _set(xx - 1, yy, tileType)
      } else if (x == 15) {
        _set(xx, yy, TileType.Path)
        _set(xx + 1, yy, tileType)
      } else if (y == 0) {
        _set(xx, yy, TileType.Path)
        _set(xx, yy - 1, tileType)
      } else if (y == 15) {
        _set(xx, yy, TileType.Path)
        _set(xx, yy + 1, tileType)
      } else {
        _set(xx, yy, tileType)
      }
    } else {
      _set(xx, yy, tileType)
    }
  }
  return result
}

export const expandTilemap_2p = (tilemap: number[]) => {
  // if (tilemap.length == 0) return []
  // let result = Array(400).fill(TileType.Void)
  const gridSize = 20
  let result = Array(gridSize * gridSize).fill(tilemap.length > 0 ? TileType.Void : TileType.Path)
  const _set = (xx: number, yy: number, tileType: number) => { result[yy * gridSize + xx] = tileType }
  for (let i = 0; i < tilemap.length; ++i) {
    const tileType = tilemap[i]
    const x = i % 16
    const y = Math.floor(i / 16)
    let xx = x + 2
    let yy = y + 2
    if ([TileType.Entry, TileType.Exit, TileType.LockedExit].includes(tileType)) {
      if (x == 0) {
        _set(xx, yy, TileType.Path)
        _set(xx - 1, yy, TileType.Path)
        _set(xx - 2, yy, tileType)
      } else if (x == 15) {
        _set(xx, yy, TileType.Path)
        _set(xx + 1, yy, TileType.Path)
        _set(xx + 2, yy, tileType)
      } else if (y == 0) {
        _set(xx, yy, TileType.Path)
        _set(xx, yy - 1, TileType.Path)
        _set(xx, yy - 2, tileType)
      } else if (y == 15) {
        _set(xx, yy, TileType.Path)
        _set(xx, yy + 1, TileType.Path)
        _set(xx, yy + 2, tileType)
      } else {
        _set(xx, yy, tileType)
      }
    } else {
      _set(xx, yy, tileType)
    }
  }
  return result
}

