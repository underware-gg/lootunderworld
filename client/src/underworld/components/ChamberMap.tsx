import { useMemo } from 'react'
import { useChamber } from '../hooks/useChamber'
import { bigintToHex } from '../utils/utils'
import { TileType } from '../utils/underworld'

interface ChamberMapProps {
  locationId: bigint,
}

function ChamberMap({
  locationId,
}: ChamberMapProps) {
  const { seed, bitmap, tilemap } = useChamber(locationId)

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
      {rows}
    </div>
  )
}

export default ChamberMap
