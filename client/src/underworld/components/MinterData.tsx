import { useEffect, useMemo, useState } from 'react'
import { useDojoSystemCalls, useDojoAccount } from '../../DojoContext'
import { useChamber, useChamberState, useChamberMap, useChamberOffset, useRealmChamberIds } from '../hooks/useChamber'
import { useUnderworldContext } from '../hooks/UnderworldContext'
import { bigintToHex } from '../utils/utils'
import { Dir, DirNames, coordToCompass, coordToSlug, offsetCompass } from '../utils/underworld'

interface Generator {
  name: string
  value: number
  description: string
}

const _generators: Generator[] = [
  // debug
  { name: 'seed', value: 0, description: '' },
  { name: 'underseed', value: 0, description: '' },
  { name: 'overseed', value: 0, description: '' },
  { name: 'protected', value: 0, description: '' },
  // default entry
  { name: 'entry', value: 0, description: '' },
  // connections
  { name: 'connection', value: 0, description: 'narrow connection' },
  { name: 'connection', value: 1, description: 'wide connection' },
  { name: 'connection', value: 2, description: 'carved connection' },
  { name: 'connection', value: 2, description: 'wider carved connection' },
  // binary tree mazes
  { name: 'binary_tree_classic', value: 0, description: '' },
  { name: 'binary_tree_pro', value: 0, description: '' },
  { name: 'binary_tree_fuzz', value: 0, description: '' },
  // collapse
  { name: 'collapse', value: 0, description: 'collapse tight' },
  { name: 'collapse', value: 1, description: 'collapse wide' },
  // carver / automata
  { name: 'carve', value: 2, description: '' },
  { name: 'carve', value: 3, description: '' },
  { name: 'carve', value: 36, description: '' },
  { name: 'carve', value: 37, description: 'entry' },
  { name: 'carve', value: 4, description: '' },
  { name: 'carve', value: 44, description: '' },
  { name: 'carve', value: 45, description: '' },
  { name: 'carve', value: 46, description: '' },
  { name: 'carve', value: 47, description: '' },
  { name: 'carve', value: 5, description: '' },
  { name: 'carve', value: 44, description: '' },
  { name: 'carve', value: 45, description: '' },
  { name: 'carve', value: 46, description: '' },
  { name: 'carve', value: 47, description: '' },
  { name: 'carve', value: 54, description: '' },
  { name: 'carve', value: 55, description: 'OK' },
  { name: 'carve', value: 56, description: '' },
  { name: 'carve', value: 57, description: '' },
  { name: 'carve', value: 6, description: '' },
  { name: 'carve', value: 63, description: '' },
  { name: 'carve', value: 64, description: '' },
  { name: 'carve', value: 65, description: '' },
  { name: 'carve', value: 7, description: '' },
  { name: 'carve', value: 8, description: '' },
  { name: 'carve', value: 9, description: '' },
  // collapse
  { name: 'collapse_carve', value: 3, description: '' },
  { name: 'collapse_carve', value: 4, description: 'OK' },
  { name: 'collapse_carve', value: 5, description: 'OK' },
  { name: 'collapse_carve', value: 6, description: '' },
]


interface DirectionButtonProps {
  chamberId: bigint
  dir: Dir
  doorTile: number
  generator: Generator
}

function DirectionButton({
  chamberId,
  dir,
  doorTile,
  generator,
}: DirectionButtonProps) {
  const { realmId, dispatch, UnderworldActions } = useUnderworldContext()
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const { locationId, seed } = useChamberOffset(chamberId, dir)
  const exists = useMemo(() => (seed > 0n), [seed, locationId])

  const _mint = () => {
    mint_realms_chamber(account, realmId, chamberId, dir, generator.name, generator.value)
  }
  const _open = () => {
    dispatch({
      type: UnderworldActions.SET_CHAMBER,
      payload: locationId,
    })
  }

  if (!exists) {
    return <button className='DirectionButton Locked' disabled={doorTile == 0} onClick={() => _mint()}>Unlock<br />{DirNames[dir]}</button>
  }
  return <button className='DirectionButton Unocked' onClick={() => _open()}>Go<br />{DirNames[dir]}</button>
}



function MinterData() {
  const { mint_realms_chamber } = useDojoSystemCalls()
  const { account } = useDojoAccount()

  const [generatorIndex, setGeneratorIndex] = useState(5)

  // Current Realm / Chamber
  const { realmId, city, chamberId, dispatch, UnderworldActions } = useUnderworldContext()
  const { seed, yonder } = useChamber(chamberId)
  const { doors } = useChamberMap(chamberId)
  const state = useChamberState(chamberId)

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
      mint_realms_chamber(account, realmId, city.coord, Dir.Under, 'entry', 0)
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
        <p>
          State: [{state.light},{state.threat},{state.wealth}]
        </p>
        <div className='Padded'>
          <DirectionButton chamberId={chamberId} dir={Dir.North} doorTile={doors?.north ?? 0} generator={_generators[generatorIndex]} />
          <div>
            <DirectionButton chamberId={chamberId} dir={Dir.West} doorTile={doors?.west ?? 0} generator={_generators[generatorIndex]} />
            <DirectionButton chamberId={chamberId} dir={Dir.East} doorTile={doors?.east ?? 0} generator={_generators[generatorIndex]} />
          </div>
          <DirectionButton chamberId={chamberId} dir={Dir.South} doorTile={doors?.south ?? 0} generator={_generators[generatorIndex]} />
        </div>

        <div>
          <select value={generatorIndex} onChange={e => setGeneratorIndex(parseInt(e.target.value))}>
            {_generators.map((g: Generator, index: number) => {
              const _desc = `${g.name}(${g.value}) : ${g.description}`
              return <option value={index} key={`gen_${index}`}>{_desc}</option>
            })}
          </select>
        </div>
      </>}

    </div>
  )
}

export default MinterData
