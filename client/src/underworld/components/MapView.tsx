import { useMemo } from 'react'
import { Compass, TileType } from '../utils/underworld'
import { MapColors } from '../utils/colors'
import { Point } from '../utils/realms'

export const compassToMapViewPos = (compass: Compass | null): Point => {
  const north = (compass?.north ?? 0)
  const east = (compass?.east ?? 0)
  const west = (compass?.west ?? 0)
  const south = (compass?.south ?? 0)
  return {
    x: compass ? (east > 0 ? east : -west + 1) : 0,
    y: compass ? (south > 0 ? south : -north + 1) : 0,
  }
}

export interface MapChamber {
  coord: bigint
  compass: Compass | null
  mapPos: Point
  tilemap: number[]
  exists: boolean
}

//----------------------------
// Maps View
//
interface MapViewProps {
  targetChamber: MapChamber
  chambers: MapChamber[]
  tileSize?: number
  viewSize?: number
}
export function MapView({
  targetChamber,
  chambers,
  tileSize = 4,
  viewSize = 350,
}: MapViewProps) {

  if (!targetChamber?.tilemap?.length) {
    return <></>
  }

  // view size in pixels
  const gridSize = Math.sqrt(targetChamber.tilemap.length)
  const chamberSize = tileSize * gridSize
  const strokeWidth = 1.0 / tileSize

  // viewbox unit is a <Map>
  const viewboxSize = viewSize / chamberSize
  const viewboxOrigin = {
    x: targetChamber.mapPos.x - ((viewboxSize - 1) / 2),
    y: targetChamber.mapPos.y - ((viewboxSize - 1) / 2),
  }

  return (
    <svg width={viewSize} height={viewSize} viewBox={`${viewboxOrigin.x} ${viewboxOrigin.y} ${viewboxSize} ${viewboxSize}`}>
      <style>{`svg{background-color:${MapColors.BG1}}`}</style>
      {chambers.map((chamber: MapChamber) => {
        const isTarget = (chamber.coord == targetChamber.coord && chamber.exists)
        return (
          <g key={`map_${chamber.coord.toString()}`} transform={`translate(${chamber.mapPos.x},${chamber.mapPos.y})`} >
            <Map tilemap={chamber.tilemap} gridSize={gridSize} strokeWidth={strokeWidth} isTarget={isTarget} />
          </g>
        )
      })}
    </svg>
  )
}


//----------------------------
// Single Map
//
interface MapProps {
  tilemap: number[]
  gridSize: number
  strokeWidth: number,
  isTarget: boolean
}
export function Map({
  tilemap,
  gridSize,
  strokeWidth,
  isTarget,
}: MapProps) {

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
          // stroke='#8881'
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
    <svg width='1' height='1' viewBox={`0 0 ${gridSize} ${gridSize}`}>
      {tiles}
      {isTarget &&
        <rect x='0' y='0' width='100%' height='100%' fill='none' stroke={MapColors.CURRENT} strokeWidth={strokeWidth * 2} />
      }
    </svg>
  )
}
