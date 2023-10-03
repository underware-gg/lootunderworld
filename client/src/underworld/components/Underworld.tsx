import { useSyncWorld } from '../hooks/useGraphQLQueries'
import { UnderworldProvider } from '../hooks/UnderworldContext'
import RealmImage from './RealmImage'
import RealmData from './RealmData'
import MinterMap from './MinterMap'
import MinterData from './MinterData'

function Underworld() {
  const { loading } = useSyncWorld()

  if (loading) {
    return <h1>loading...</h1>
  }

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
