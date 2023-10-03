import { useMemo } from 'react'
import { useChamber } from '../hooks/useChamber'
import { bigintToHex } from '../utils/utils'
import { TileType } from '../utils/underworld'




interface AsciiMapProps {
  tilemap: number[],
}
export function AsciiMap({
  tilemap,
}: AsciiMapProps) {

  const rows = useMemo(() => {
    const result: any = []
    for (let y = 0; y < 16; ++y) {
      let row = ''
      for (let x = 0; x < 16; ++x) {
        const tileType = tilemap[y * 16 + x]
        if (tileType == TileType.Path) {
          row += '.'
        } else if (tileType == TileType.Entry) {
          row += 'E'
        } else if (tileType == TileType.Exit) {
          row += 'X'
        } else if (tileType == TileType.LockedExit) {
          row += '+'
        } else {
          row += '0'
        }
      }
      result.push(<div key={`row_${y}`}>{row}</div>)
    }
    return result
  }, [tilemap])

  return (
    <>
      {rows}
    </>
  )
}

enum COLOR {
  BG1 = '#181818',
  BG2 = '#111',
  WALL = '#666',
  ENTRY = '#aa0',
  EXIT = '#0aa',
  LOCKED = '#a00',
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


interface ChamberMapProps {
  locationId: bigint,
}
function ChamberMap({
  locationId,
}: ChamberMapProps) {
  const { seed, bitmap, tilemap } = useChamber(locationId)

  const style = {
    fontFamily: 'monospace',
    lineHeight: '0.8em',
  }

  return (
    <div style={style}>
      <p>
        location: {bigintToHex(locationId)}
        <br />
        {locationId.toString()}
      </p>
      <p>
        seed: {bigintToHex(seed)}
        <br />
        {seed.toString()}
      </p>
      <p>
        bitmap: {bigintToHex(bitmap)}
        <br />
        {bitmap.toString()}
      </p>
      <Map tilemap={tilemap} tileSize={8} />
      {/* <AsciiMap tilemap={tilemap} /> */}
    </div>
  )
}

export default ChamberMap
