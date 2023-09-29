import Minter from './Minter'
import { useSyncWorld } from '../hooks/useGraphQLQueries'
import { UnderworldProvider } from '../hooks/UnderworldContext'
import RealmPanel from './RealmPanel'

function Underworld() {
  const { loading } = useSyncWorld()

  if (loading) {
    return <h1>loading...</h1>
  }

  return (
    <UnderworldProvider>
      <RealmPanel />
      <hr />
      <Minter />
    </UnderworldProvider>
  )
}

export default Underworld
