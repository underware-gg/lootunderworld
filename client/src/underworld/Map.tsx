import { useMemo } from 'react';
import { useDojo } from '../DojoContext';
import { EntityIndex, setComponent, HasValue, Has } from '@latticexyz/recs';
import { useComponentValue, useEntityQuery } from "@dojoengine/react";

interface ChamberMapProps {
  entityId: number,
}

function ChamberMap(props: ChamberMapProps) {
  const {
    setup: {
      // systemCalls: { spawn, move, generate_chamber },
      components: { Chamber, Map },
    },
    // account: { create, list, select, account, isDeploying }
  } = useDojo();

  const chamber = useComponentValue(Chamber, props.entityId as EntityIndex);
  const seed = BigInt(chamber?.seed ?? 0)

  const map = useComponentValue(Map, props.entityId as EntityIndex);
  const bitmap = BigInt(map?.bitmap ?? 0)
  console.log(`map:`, map, typeof map?.bitmap, bitmap)

  const rows = useMemo(() => {
    const result: any = []
    for (let y = 0; y < 16; ++y) {
      let row = ''
      for (let x = 0; x < 16; ++x) {
        const bit = bitmap & (BigInt(1) << BigInt(y * 16 + x))
        row += bit ? '0' : '.'
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
