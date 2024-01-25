import React, { useEffect, useState } from 'react'
import { useUnderworldContext } from '@/underworld/hooks/UnderworldContext'
import { MapChamber, MapView } from '@/underworld/components/MapView'
import { useLootUnderworld } from '@avante/crawler-react'


//-----------------------------
// Entry Point
//
function MinterMap() {
  const { underworld } = useLootUnderworld()
  const [tileSize, seTtileSize] = useState(5)
  const { realmId, chamberId: currentChamberId } = useUnderworldContext()

  useEffect(() => {
    setChambers({})
  }, [realmId])

  // loaded tilemaps
  const [chambers, setChambers] = useState<{ [key: string]: MapChamber }>({})

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

export default MinterMap
