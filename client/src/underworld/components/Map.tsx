import { useMemo } from 'react'
import { TileType } from '../utils/underworld'

enum COLOR {
  BG1 = '#181818',
  BG2 = '#111',
  WALL = '#94631f',
  ENTRY = '#aa0',
  LOCKED = '#c1965d',
  EXIT = '#fbf6c0',
}

interface MapProps {
  tilemap: number[],
  tileSize: number,
}
export function Map({
  tilemap,
  tileSize=10,
}: MapProps) {

  const gridSize = Math.sqrt(tilemap.length)
  const width = tileSize * gridSize
  const height = tileSize * gridSize
  // const strokeWidth = 1.0 / tileSize

  const tiles = useMemo(() => {
    const result: any = []
    for (let i = 0; i < tilemap.length; ++i) {
      const tileType = tilemap[i]
      const x = i % gridSize
      const y = Math.floor(i / gridSize)
      let tile = null
      let tileColor = null
      if (tileType == TileType.Path) {
      } else if (tileType == TileType.Entry) {
        tileColor = COLOR.ENTRY
      } else if (tileType == TileType.Exit) {
        tileColor = COLOR.EXIT
      } else if (tileType == TileType.LockedExit) {
        tileColor = COLOR.LOCKED
      } else {
        tileColor = COLOR.WALL
      }
      if (!tile && !tileColor && (x + y) % 2 == 0) {
        tileColor = COLOR.BG2
      }
      if(!tile && tileColor) {
        tile = <rect
          x={x}
          y={y}
          width='1'
          height='1'
          fill={tileColor}
          // stroke='#8882'
          // strokeWidth={strokeWidth}
        />
      }
      if (tile) {
        result.push(tile)
      }
    }
    return result
  }, [tilemap])

  return (
    <svg width={width} height={height} viewBox={`0 0 ${gridSize} ${gridSize}`}>
      <rect x='0' y='0' width='100%' height='100%' fill={COLOR.BG1} />
      {tiles}
    </svg>
  )
}

