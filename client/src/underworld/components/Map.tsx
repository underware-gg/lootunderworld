import { useMemo } from 'react'
import { TileType } from '../utils/underworld'
import { MapColors } from '../utils/colors'

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
        tileColor = MapColors.ENTRY
      } else if (tileType == TileType.Exit) {
        tileColor = MapColors.EXIT
      } else if (tileType == TileType.LockedExit) {
        tileColor = MapColors.LOCKED
      } else {
        tileColor = MapColors.WALL
      }
      if (!tile && !tileColor && (x + y) % 2 == 0) {
        tileColor = MapColors.BG2
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
      <rect x='0' y='0' width='100%' height='100%' fill={MapColors.BG1} />
      {tiles}
    </svg>
  )
}

