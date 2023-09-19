import { useEffect, useMemo } from 'react';
import { useDojo } from '../../DojoContext';
import { Entity, setComponent, HasValue, Has } from '@latticexyz/recs';
import { useComponentValue, useEntityQuery } from "@dojoengine/react";

interface ChamberMapProps {
  entity: Entity,
}

function ChamberMap(props: ChamberMapProps) {
  const {
    setup: {
      // systemCalls: { spawn, move, generate_chamber },
      components: { Chamber, Map, Door },
    },
    // account: { create, list, select, account, isDeploying }
  } = useDojo();

  const chamber = useComponentValue(Chamber, props.entity);
  const seed = BigInt(chamber?.seed ?? 0)

  const map = useComponentValue(Map, props.entity);
  const bitmap = BigInt(map?.bitmap ?? 0)
  // useEffect(() => console.log(`map:`, map, typeof map?.bitmap, bitmap), [bitmap])

  const doorsIds = useEntityQuery([HasValue(Door, { to_location: chamber?.location ?? 0n })]);
  useEffect(() => console.log(`doorsIds:`, doorsIds), [doorsIds])
  const door0 = useComponentValue(Door, (doorsIds?.[0] ?? '0') as Entity);
  useEffect(() => console.log(`door0:`, door0), [door0])

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

export default ChamberMap;
