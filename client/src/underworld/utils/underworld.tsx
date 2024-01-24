import { TileType } from "@avante/crawler-core"

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
