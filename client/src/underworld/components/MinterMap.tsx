import { useUnderworldContext } from '../hooks/UnderworldContext'
import { useChamber } from '../hooks/useChamber'
// import { MapAscii } from './MapAscii'
import { Map } from './Map'

function MinterMap() {
  const { chamberId } = useUnderworldContext()

  const { tilemap, expandedTilemap } = useChamber(chamberId ?? 0n)

  return (
    <div className='MinterMap'>
      <Map tilemap={expandedTilemap} tileSize={8} />
      {/* <MapAscii tilemap={tilemap} /> */}
    </div>
  )
}

export default MinterMap
