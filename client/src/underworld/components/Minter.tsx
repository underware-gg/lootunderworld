import { useEffect, useState } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useRealmChamberIds } from '../hooks/useChamber'
import { Dir } from '../utils/underworld'
import ChamberMap from './ChamberMap'
import { bigintToHex } from '../utils/utils'
 
function Minter() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const [realmId, setRealmId] = useState(1);

  const { chamberIds } = useRealmChamberIds(realmId)

  const [selectedChamberId, setSelectedChamberId] = useState(0n)
  useEffect(() => {
    setSelectedChamberId(chamberIds.length > 0 ? chamberIds[chamberIds.length - 1] : 0n)
  }, [chamberIds])

  return (
    <div className="card">
      <div>
        <button onClick={() => mint_realms_chamber(account, realmId, BigInt(Date.now() % 999) | (BigInt(Date.now() % 999) << 32n), Dir.Under)}>Mint Chamber</button>
      </div>
      <br />
      <div>
        <select onChange={e => setSelectedChamberId(BigInt(e.target.value))}>
          {chamberIds.map((locationId) => {
            const _id = locationId.toString()
            return <option value={_id} key={_id}>{bigintToHex(locationId)}</option>
          })}
        </select>
      </div>
      <div>
        <ChamberMap locationId={selectedChamberId} />
      </div>
    </div>
  )
}

export default Minter
