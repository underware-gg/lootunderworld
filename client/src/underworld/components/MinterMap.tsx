import { useEffect, useMemo, useState } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useChamberMap } from '../hooks/useChamber'
import { MapChamber, MapView, compassToMapViewPos } from './MapView'
import { coordToCompass } from '../utils/underworld'

function MinterMap() {
  const [tileSize, seTtileSize] = useState(5)
  const { chamberId: currentChamberId } = useUnderworldContext()

  useEffect(() => {
    _addLoader(currentChamberId)
  }, [currentChamberId])

  // tilemap loaders
  const [loaders, setLoaders] = useState<bigint[]>([])
  const _addLoader = (chamberId: bigint) => {
    if (!loaders.includes(chamberId)) {
      setLoaders([...loaders, chamberId])
    }
  }

  // loaded tilemaps
  const [chambers, setChambers] = useState<{ [key: string]: MapChamber }>({})
  const _addChamber = (chamber: MapChamber) => {
    const _key = chamber.coord.toString()
    setChambers({
      ...chambers,
      [_key]: chamber,
    })
  }
  const mapChambers = useMemo(() => Object.values(chambers), [chambers])
  const targetChamber = useMemo(() => {
    return (chambers[currentChamberId.toString()] ?? {})
  }, [currentChamberId, chambers])

  return (
    <div className='MinterMap'>
      {loaders.map((coord: bigint) => {
        return <MapLoader key={`loader_${coord.toString()}`} coord={coord} addChamber={_addChamber} />
      })}
      <MapView targetChamber={targetChamber} chambers={mapChambers} tileSize={tileSize} />

      <div className='AlignBottom'>
        zoom&nbsp;
        {[2, 3, 4, 5, 6, 8, 10, 12, 16].map((value: number) => {
          return <button key={`tileSize_${value}`} className={`SmallButton ${value == tileSize ? 'Unlocked' : 'Locked'}`} onClick={() => seTtileSize(value)}>{value}</button>
        })}
      </div>
    </div>
  )
}

interface MapLoaderProps {
  coord: bigint,
  addChamber: (chamber: MapChamber) => void,
}
function MapLoader({
  coord,
  addChamber,
}: MapLoaderProps) {
  const { tilemap, expandedTilemap } = useChamberMap(coord)
  useEffect(() => {
    if (expandedTilemap) {
      const compass = coordToCompass(coord)
      addChamber({
        coord,
        compass,
        mapPos: compassToMapViewPos(compass),
        tilemap: expandedTilemap,
        exists: (tilemap.length > 0),
      })
    }
  }, [coord, expandedTilemap])
  return <></>
}

export default MinterMap
