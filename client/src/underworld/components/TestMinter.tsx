import { useEffect, useState, useMemo } from 'react';
import { useDojo } from '../../DojoContext';
import { Entity, Has } from '@latticexyz/recs';
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { Dir } from '../utils/underworld';

interface TestMapProps {
  entity: Entity,
}

function TestMap(props: TestMapProps) {
  const {
    setup: {
      // systemCalls: { spawn, move, mint_realms_chamber },
      components: { Chamber, Map },
    },
    // account: { create, list, select, account, isDeploying }
  } = useDojo();

  const chamber: any = useComponentValue(Chamber, props.entity);
  const seed = BigInt(chamber?.seed ?? 0)

  const map: any = useComponentValue(Map, props.entity);
  const bitmap = BigInt(map?.bitmap ?? 0)
  // useEffect(() => console.log(`map:`, map, typeof map?.bitmap, bitmap), [bitmap])

  // const doorsIds = useEntityQuery([HasValue(Door, { to_location: chamber?.location ?? 0n })]);
  // useEffect(() => console.log(`doorsIds:`, doorsIds), [doorsIds])
  // const door0 = useComponentValue(Door, (doorsIds?.[0] ?? '0') as Entity);
  // useEffect(() => console.log(`door0:`, door0), [door0])

  const rows = useMemo(() => {
    const result: any = []
    for (let y = 0; y < 16; ++y) {
      let row = ''
      for (let x = 0; x < 16; ++x) {
        const bit = bitmap & (BigInt(1) << BigInt(y * 16 + x))
        row += bit ? '.' : '0'
      }
      result.push(<div key={`row_${y}`}>{row}</div>)
    }
    return result
  }, [bitmap])

  const style = {
    fontFamily: 'monospace',
    lineHeight: '0.8em',
  }

  return (
    <div style={style}>
      <p>
        seed: 0x{seed.toString(16)}
        <br />
        {seed.toString()}
      </p>
      <p>
        bitmap: 0x{bitmap.toString(16)}
        <br />
        {bitmap.toString()}
      </p>
      {rows}
    </div>
  );
}

function TestMinter() {
  const {
    setup: {
      systemCalls: { mint_realms_chamber },
      components: { Chamber },
    },
    account: { account }
  } = useDojo();

  // const chamberIds = useEntityQuery([HasValue(Chamber, { realm_id: 1 })]);
  const chamberIds = useEntityQuery([Has(Chamber)]);

  const [selectedChamberId, setSelectedChamberId] = useState('0')
  useEffect(() => {
    setSelectedChamberId(chamberIds[chamberIds.length - 1] ?? 0)
  }, [chamberIds])

  return (
    <div className="card">
      <button onClick={() => mint_realms_chamber(account, 1, BigInt(Date.now() % 999) | (BigInt(Date.now() % 999) << 32n), Dir.Under, 'seed', 0)}>Mint Chamber</button>
      <div>
        <select onChange={e => setSelectedChamberId(e.target.value as Entity)}>
          {chamberIds.map((entityId) => {
            const _id = entityId.toString()
            return <option value={_id} key={_id}>{_id}</option>
          })}
        </select>
      </div>
      <div>
        <TestMap entity={selectedChamberId as Entity} />
      </div>
    </div>
  );
}

export default TestMinter;
