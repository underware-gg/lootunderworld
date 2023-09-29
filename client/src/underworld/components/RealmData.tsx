import { useRealmMetadata } from '../hooks/useRealm'

interface ChamberMapProps {
  realmId: number,
}

function RealmImage({
  realmId,
}: ChamberMapProps) {
  const { metadata } = useRealmMetadata(realmId)

  return (
    <div className='RealmImage AlignTop'>
      <h2>
        Realm #{realmId}
        <br />
        {metadata.name}
      </h2>

      {/* <select onChange={e => setSelectedChamberId(BigInt(e.target.value))}>
          {chamberIds.map((locationId) => {
            const _id = locationId.toString()
            return <option value={_id} key={_id}>{bigintToHex(locationId)}</option>
          })}
        </select> */}
    </div>
  )
}

export default RealmImage
