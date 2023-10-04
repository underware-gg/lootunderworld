import { useMemo } from 'react'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useChamberMap } from '../hooks/useChamber'
import { MapChamber, MapView } from './MapView'

function MinterMap() {
  const { chamberId } = useUnderworldContext()

  const { expandedTilemap } = useChamberMap(chamberId)
  const chamber: MapChamber = useMemo(() => ({
    coord: chamberId,
    tilemap: expandedTilemap,
  }), [expandedTilemap])

  return (
    <div className='MinterMap'>
      <MapView chambers={[chamber]} />
    </div>
  )
}

export default MinterMap
