import { useEffect, useMemo } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useChamber, useChamberOffset, useRealmChamberIds } from '../hooks/useChamber'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { bigintToHex } from '../utils/utils'
import { Dir, DirNames, coordToCompass, coordToSlug, offsetCompass } from '../utils/underworld'

interface DirectionButtonProps {
  chamberId: bigint,
  dir: Dir,
}

function DirectionButton({
  chamberId,
  dir,
}: DirectionButtonProps) {
  const { realmId, dispatch, UnderworldActions } = useUnderworldContext()
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const { locationId, seed } = useChamberOffset(chamberId, dir)
  const exists = useMemo(() => (seed > 0n), [seed, locationId])

  const _mint = () => {
    mint_realms_chamber(account, realmId, chamberId, dir)
  }
  const _open = () => {
    dispatch({
      type: UnderworldActions.SET_CHAMBER,
      payload: locationId,
    })
  }

  if (!exists) {
    return <button className='DirectionButton Locked' onClick={() => _mint()}>Mint {DirNames[dir]}</button>
  }
  return <button className='DirectionButton Unocked' onClick={() => _open()}>Open {DirNames[dir]}</button>
}



function MinterData() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  // Current Realm / Chamber
  const { realmId, city, chamberId, dispatch, UnderworldActions } = useUnderworldContext()
  const { seed, yonder } = useChamber(chamberId)
  const chamberExists = useMemo(() => (seed > 0), [seed])
  const canMintFirst = useMemo(() => (realmId > 0 && city != null && !chamberExists), [realmId, city, chamberExists])

  // Chambers list
  // TODO: REMOVE THIS
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

  const _mintFirst = () => {
    if (canMintFirst && city) {
      mint_realms_chamber(account, realmId, city.coord, Dir.Under)
    }
  }

  // useEffect(() => {
  //   const compass = coordToCompass(chamberId)
  //   console.log(`CHAMBER:`, compass)
  //   console.log(`+ NORTH:`, offsetCompass(compass, Dir.North))
  //   console.log(`+ EAST:`, offsetCompass(compass, Dir.East))
  //   console.log(`+ WEST:`, offsetCompass(compass, Dir.West))
  //   console.log(`+ SOUTH:`, offsetCompass(compass, Dir.South))
  // }, [chamberId])

  return (
    <div className='MinterData AlignTop'>
      <p>
        @ Realm#{realmId} [{city?.name ?? '?'}]
        <br />
        {bigintToHex(city?.coord ?? 0n)}
      </p>

      {!chamberExists && <>
        <div>
          <button disabled={!canMintFirst} onClick={() => _mintFirst()}>Create Underground</button>
        </div>
        <br />
      </>}

      {chamberExists && <>
        <div>
          <select value={chamberId?.toString()} onChange={e => _selectChamber(BigInt(e.target.value))}>
            {chamberIds.map((locationId) => {
              const _id = locationId.toString()
              return <option value={_id} key={_id}>{coordToSlug(locationId)}</option>
            })}
          </select>
        </div>

        <p>
          Compass: <b>{coordToSlug(chamberId, yonder)}</b>
          <br />
          <b>{bigintToHex(chamberId)}</b>
        </p>
        <p>
          Yonder: <b>{yonder}</b>
        </p>
        <div className='Padded'>
          <DirectionButton chamberId={chamberId} dir={Dir.North} />
          <div>
            <DirectionButton chamberId={chamberId} dir={Dir.West} />
            <DirectionButton chamberId={chamberId} dir={Dir.East} />
          </div>
          <DirectionButton chamberId={chamberId} dir={Dir.South} />
        </div>
      </>}

    </div>
  )
}

export default MinterData
