import { useEffect, useMemo, useState } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useChamber, useChamberDoors, useChamberOffset, useRealmChamberIds } from '../hooks/useChamber'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { bigintToHex } from '../utils/utils'
import { Dir, DirNames, coordToCompass, coordToSlug, offsetCompass } from '../utils/underworld'

interface DirectionButtonProps {
  chamberId: bigint,
  dir: Dir,
  algo: number,
}

function DirectionButton({
  chamberId,
  dir,
  algo,
}: DirectionButtonProps) {
  const { realmId, dispatch, UnderworldActions } = useUnderworldContext()
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const { locationId, seed } = useChamberOffset(chamberId, dir)
  const exists = useMemo(() => (seed > 0n), [seed, locationId])

  const _mint = () => {
    mint_realms_chamber(account, realmId, chamberId, dir, algo)
  }
  const _open = () => {
    dispatch({
      type: UnderworldActions.SET_CHAMBER,
      payload: locationId,
    })
  }

  if (!exists) {
    return <button className='DirectionButton Locked' onClick={() => _mint()}>Unlock<br/>{DirNames[dir]}</button>
  }
  return <button className='DirectionButton Unocked' onClick={() => _open()}>Go<br />{DirNames[dir]}</button>
}


function MinterData() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const [algo, setAlgo] = useState(0)

  // Current Realm / Chamber
  const { realmId, city, chamberId, dispatch, UnderworldActions } = useUnderworldContext()
  const { seed, yonder } = useChamber(chamberId)
  const doors = useChamberDoors(chamberId)
  
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
      mint_realms_chamber(account, realmId, city.coord, Dir.Under, algo)
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
          <b>{coordToSlug(chamberId, yonder)}</b>
          <br />
          {bigintToHex(chamberId)}
          <br />
          {chamberId.toString()}
        </p>
        <p>
          Yonder: <b>{yonder}</b>
        </p>
        <p>
          Doors: [{doors.north},{doors.east},{doors.west},{doors.south}]
        </p>
        <div className='Padded'>
          <DirectionButton chamberId={chamberId} dir={Dir.North} algo={algo} />
          <div>
            <DirectionButton chamberId={chamberId} dir={Dir.West} algo={algo} />
            <DirectionButton chamberId={chamberId} dir={Dir.East} algo={algo} />
          </div>
          <DirectionButton chamberId={chamberId} dir={Dir.South} algo={algo} />
        </div>
      </>}

      <div>
        <select value={algo} onChange={e => setAlgo(parseInt(e.target.value))}>
          {[
            { value: 0, name: 'none' },
            { value: 1, name: 'collapse(false)' },
            { value: 2, name: 'collapse(true)' },
            // mazes
            { value: 10, name: 'maze_binary_tree()' },
            { value: 11, name: 'maze_binary_fuzz()' },
            // collapse
            { value: 93, name: 'collapse()+carve(%)' },
            { value: 94, name: 'collapse()+carve(%) OK' },
            { value: 95, name: 'collapse()+carve(%) OK' },
            { value: 96, name: 'collapse()+carve(%)' },
            // carver / automata
            { value: 120, name: 'carve(%)' },
            { value: 130, name: 'carve(%)' },
            { value: 136, name: 'carve(%)' },
            { value: 137, name: 'carve(%)-OK' },
            { value: 140, name: 'carve(%)' },
            { value: 150, name: 'carve(%)' },
            { value: 144, name: 'carve(%)' },
            { value: 145, name: 'carve(%)' },
            { value: 146, name: 'carve(%)' },
            { value: 147, name: 'carve(%)' },
            { value: 154, name: 'carve(%)' },
            { value: 155, name: 'carve(%)-OK' },
            { value: 160, name: 'carve(%)' },
            { value: 163, name: 'carve(%)' },
            { value: 164, name: 'carve(%)' },
            { value: 165, name: 'carve(%)' },
            { value: 170, name: 'carve(%)' },
            { value: 180, name: 'carve(%)' },
            { value: 190, name: 'carve(%)' },
          ].map((a:any) => {
            return <option value={a.value} key={`k${a.value}`}>{`${a.value}: ${a.name}`}</option>
          })}
        </select>
      </div>

    </div>
  )
}

export default MinterData
