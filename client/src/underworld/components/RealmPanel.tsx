import { useUnderworldContext } from '../hooks/UnderworldContext'
import RealmImage from './RealmImage'
import RealmData from './RealmData'

function RealmPanel() {
  const { realmId, cityIndex } = useUnderworldContext();

  return (
    <div className="card RealmPanel">
      <RealmImage realmId={realmId} />
      <RealmData realmId={realmId} />
    </div>
  )
}

export default RealmPanel
