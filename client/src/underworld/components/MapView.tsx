import { useMemo } from 'react'
import { TileType } from '../utils/underworld'
import { MapColors } from '../utils/colors'


interface MapViewProps {
  tilemaps: number[][]
  tileSize: number
  viewboxSize?: number
}
export function MapView({
  tilemaps,
  tileSize = 10,
  viewboxSize = 350,
}: MapViewProps) {

  const gridSize = Math.sqrt(tilemaps[0]?.length ?? 0)
  const chamberSize = tileSize * gridSize
  const viewStart = (viewboxSize - chamberSize) / 2

  return (
    <svg width={viewboxSize} height={viewboxSize} viewBox={`${-viewStart} ${-viewStart} ${viewboxSize} ${viewboxSize}`}>
      <style>{`svg{background-color:${MapColors.BG1}}`}</style>
      {tilemaps.map((tilemap: number[], index: number) => {
        return <Map key={`map_${index}`} tilemap={tilemap} gridSize={gridSize} chamberSize={chamberSize} />
      })}
    </svg>
  )
}


interface MapProps {
  tilemap: number[]
  gridSize: number
  chamberSize: number
}
export function Map({
  tilemap,
  gridSize,
  chamberSize,
}: MapProps) {

  // const strokeWidth = 1.0 / tileSize

  const tiles = useMemo(() => {
    const result: any = []
    for (let i = 0; i < tilemap.length; ++i) {
      const key = `tile_${i}`
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
      if (!tile && tileColor) {
        tile = <rect
          key={key}
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
    <svg width={chamberSize} height={chamberSize} viewBox={`0 0 ${gridSize} ${gridSize}`}>
      {tiles}
    </svg>
  )
}
