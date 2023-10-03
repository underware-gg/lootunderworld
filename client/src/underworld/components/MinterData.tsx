import { useEffect, useMemo } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useRealmChamberIds } from '../hooks/useChamber'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { bigintToHex } from '../utils/utils'
import { Dir, coordToSlug } from '../utils/underworld'

function MinterMap() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const { realmId, city, chamberId, dispatch, UnderworldActions } = useUnderworldContext()
  const canMint = useMemo(() => (realmId > 0 && city != null), [realmId, city])

  const { chamberIds } = useRealmChamberIds(realmId)

  useEffect(() => {
    _selectChamber(chamberIds.length > 0 ? chamberIds[chamberIds.length - 1] : 0n)
  }, [chamberIds])

  const _selectChamber = (coord: bigint) => {
    dispatch({
      type: UnderworldActions.SET_CHAMBER,
      payload: coord,
    })
  }

  const _mint = () => {
    if (canMint && city) {
      mint_realms_chamber(account, realmId, city.coord, Dir.Under)
    }
  }

  return (
    <div className='MinterData AlignTop'>
      <p>
        @ Realm#{realmId} [{city?.name ?? '?'}]
        <br />
        {bigintToHex(city?.coord ?? 0n)}
      </p>
      <div>
        <button disabled={!canMint} onClick={() => _mint()}>Mint Chamber</button>
      </div>
      <br />
      <div>
        <select value={chamberId?.toString()} onChange={e => _selectChamber(BigInt(e.target.value))}>
          {chamberIds.map((locationId) => {
            const _id = locationId.toString()
            return <option value={_id} key={_id}>{coordToSlug(locationId)}</option>
          })}
        </select>
      </div>

      <p>
        Compass: <b>{coordToSlug(chamberId ?? 0n)}</b>
      </p>
      <p>
        Coord: <b>{bigintToHex(chamberId ?? 0n)}</b>
      </p>

    </div>
  )
}

export default MinterMap
