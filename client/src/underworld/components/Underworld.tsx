import { UnderworldProvider } from '../hooks/UnderworldContext'
import RealmImage from './RealmImage'
import RealmData from './RealmData'
import MinterMap from './MinterMap'
import MinterData from './MinterData'

function Underworld() {
  return (
    <UnderworldProvider>
      <div className="card RealmPanel">
        <RealmImage />
        <RealmData />
      </div>
      <div className="card MinterPanel">
        <MinterMap />
        <MinterData />
      </div>
    </UnderworldProvider>
  )
}

export default Underworld
