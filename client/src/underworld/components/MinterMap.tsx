import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useChamberMap } from '../hooks/useChamber'
import { MapView } from './MapView'

function MinterMap() {
  const { chamberId } = useUnderworldContext()

  const { tilemap, expandedTilemap } = useChamberMap(chamberId)

  return (
    <div className='MinterMap'>
      <MapView tilemaps={[expandedTilemap]} tileSize={8} />
    </div>
  )
}

export default MinterMap
