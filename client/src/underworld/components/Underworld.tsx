import { UnderworldProvider } from '@/underworld/hooks/UnderworldContext'
import RealmImage from '@/underworld/components/RealmImage'
import RealmData from '@/underworld/components/RealmData'
import MinterMap from '@/underworld/components/MinterMap'
import MinterData from '@/underworld/components/MinterData'

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
