import { useEffect, useMemo, useState } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useRealmChamberIds } from '../hooks/useChamber'
import { Dir } from '../utils/underworld'
import ChamberMap from './ChamberMap'
import { bigintToHex } from '../utils/utils'
import { useUnderworldContext } from '../hooks/UnderworldContext'

function Minter() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const { realmId, city } = useUnderworldContext()
  const canMint = useMemo(() => (realmId > 0 && city.coord > 0n), [realmId, city])

  const { chamberIds } = useRealmChamberIds(realmId)

  const [selectedChamberId, setSelectedChamberId] = useState(0n)
  useEffect(() => {
    setSelectedChamberId(chamberIds.length > 0 ? chamberIds[chamberIds.length - 1] : 0n)
  }, [chamberIds])

  const _mint = () => {
    if (canMint) {
      mint_realms_chamber(account, realmId, city.coord, Dir.Under)
    }
  }

  return (
    <div className="card">
      <p>
        @ Realm#{realmId} [{city.name}] {bigintToHex(city.coord ?? 0n)}
      </p>
      <div>
        <button disabled={!canMint} onClick={() => _mint()}>Mint Chamber</button>
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
