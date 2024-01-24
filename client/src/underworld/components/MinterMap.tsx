import React, { useEffect, useMemo, useState } from 'react'
import { useUnderworldContext } from '@/underworld/hooks/UnderworldContext'
import { useChamber, useChamberMap } from '@/underworld/hooks/useChamber'
import { MapChamber, MapView, compassToMapViewPos } from '@/underworld/components/MapView'
import { Dir } from '@avante/crawler-core'
import { useLootUnderworld } from '@avante/crawler-react'


//-----------------------------
// Entry Point
//
function MinterMap() {
  const { underworld } = useLootUnderworld()
  const [tileSize, seTtileSize] = useState(5)
  const { realmId, chamberId: currentChamberId } = useUnderworldContext()

  useEffect(() => {
    setLoaders([])
    setChambers({})
  }, [realmId])

  useEffect(() => {
    if (currentChamberId > 0) {
      _addLoaders([currentChamberId])
    }
  }, [currentChamberId])

  // tilemap loaders
  const [loaders, setLoaders] = useState<bigint[]>([])
  const _addLoaders = (chamberIds: bigint[]) => {
    let newLoaders = []
    chamberIds.forEach(chamberId => {
      if (!loaders.includes(chamberId)) {
        newLoaders.push(chamberId)
      }
    });
    if (newLoaders.length > 0) {
      setLoaders([...loaders, ...newLoaders])
    }
  }

  // loaded tilemaps
  const [chambers, setChambers] = useState<{ [key: string]: MapChamber }>({})
  const _addChamber = (chamber: MapChamber) => {
    const _key = underworld.coordToSlug(chamber.coord)
    if (!chambers[_key]) {
      setChambers({
        ...chambers,
        [_key]: chamber,
      })
      _addLoaders([
        underworld.offsetCoord(chamber.coord, Dir.North),
        underworld.offsetCoord(chamber.coord, Dir.East),
        underworld.offsetCoord(chamber.coord, Dir.West),
        underworld.offsetCoord(chamber.coord, Dir.South),
      ])
    }
  }

  // target (center)
  const [targetChamber, setTargetChamber] = useState<MapChamber>({} as MapChamber)
  useEffect(() => {
    const _key = underworld.coordToSlug(currentChamberId)
    if (chambers[_key]) {
      setTargetChamber(chambers[_key])
    }
  }, [currentChamberId, chambers])

  return (
    <div className='MinterMap'>
      {loaders.map((coord: bigint) => {
        return <MapPreLoader key={`loader_${coord.toString()}`} coord={coord} addChamber={_addChamber} />
      })}
      <div className='MinterMap NoBorder'>
        <MapView targetChamber={targetChamber} chambers={Object.values(chambers)} tileSize={tileSize} />
      </div>

      <div className='AlignBottom'>
        tile&nbsp;
        {[2, 3, 4, 5, 6, 8, 10, 12, 16].map((value: number) => {
          return <button key={`tileSize_${value}`} className={`SmallButton ${value == tileSize ? 'Unlocked' : 'Locked'}`} onClick={() => seTtileSize(value)}>{value}</button>
        })}
      </div>
    </div>
  )
}

function MapPreLoader({
  coord,
  addChamber,
}) {
  const { chamberExists } = useChamber(coord)
  if (chamberExists) {
    return <MapLoader coord={coord} addChamber={addChamber} />
  }
  return <></>
}

function MapLoader({
  coord,
  addChamber,
}) {
  const { underworld } = useLootUnderworld()
  const { bitmap, tilemap, expandedTilemap } = useChamberMap(coord)
  useEffect(() => {
    if (bitmap > 0n && expandedTilemap) {
      const compass = underworld.coordToCompass(coord)
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
