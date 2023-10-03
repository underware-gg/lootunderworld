import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useChamberMap } from '../hooks/useChamber'
// import { MapAscii } from './MapAscii'
import { Map } from './Map'

function MinterMap() {
  const { chamberId } = useUnderworldContext()

  const { tilemap, expandedTilemap } = useChamberMap(chamberId)

  return (
    <div className='MinterMap'>
      <Map tilemap={expandedTilemap} tileSize={8} />
      {/* <MapAscii tilemap={tilemap} /> */}
    </div>
  )
}

export default MinterMap
