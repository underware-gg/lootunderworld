
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

export interface Compass {
  north?: number
  east?: number
  west?: number
  south?: number
  over?: number
  under?: number
}

// From Crawler SDK

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
  return true
}

export const slugSeparators = [null, '', ',', '.', ';', '-'] as const
export const defaultSlugSeparator = ','
export type SlugSeparator = typeof slugSeparators[number]

export const compassToSlug = (compass: Compass | null, separator: SlugSeparator = defaultSlugSeparator): string | null => {
  if (!compass || !validateCompass(compass)) return null
  let result = ''
  if (compass.north && compass.north > 0) result += `N${compass.north}`
  if (compass.south && compass.south > 0) result += `S${compass.south}`
  if (separator) result += separator
  if (compass.east && compass.east > 0) result += `E${compass.east}`
  if (compass.west && compass.west > 0) result += `W${compass.west}`
  return result
}

export const compassToCoord = (compass: Compass | null): bigint => {
  let result = 0n
  if (compass) {
    if (compass.over && compass.over > 0) result += BigInt(compass.over) << 80n
    if (compass.under && compass.under > 0) result += BigInt(compass.under) << 64n
    if (compass.north && compass.north > 0) result += BigInt(compass.north) << 48n
    if (compass.east && compass.east > 0) result += BigInt(compass.east) << 32n
    if (compass.west && compass.west > 0) result += BigInt(compass.west) << 16n
    if (compass.south && compass.south > 0) result += BigInt(compass.south)
  }
  return result
}
