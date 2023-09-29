import { useRealmMetadata } from '../hooks/useRealm'

interface ChamberMapProps {
  realmId: number,
}

function RealmImage({
  realmId,
}: ChamberMapProps) {
  const { metadata } = useRealmMetadata(realmId)

  return (
    <div className='RealmImage'>
      {metadata.image &&
        <img className='RealmImage' src={metadata.image} />
      }
    </div>
  )
}

export default RealmImage
