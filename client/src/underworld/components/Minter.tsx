import { useEffect, useState } from 'react';
import { useDojo } from '../../DojoContext';
import { Entity, Has } from '@latticexyz/recs';
import { useEntityQuery } from "@latticexyz/react";
import ChamberMap from './Map';
import { Dir } from '../underworld';

function Minter() {
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
      <button onClick={() => mint_realms_chamber(account, 1, BigInt(Date.now() % 999) | (BigInt(Date.now() % 999) << 32n), Dir.Under)}>Mint Chamber</button>
      <div>
        <select onChange={e => setSelectedChamberId(e.target.value as Entity)}>
          {chamberIds.map((entityId) => {
            const _id = entityId.toString()
            return <option value={_id} key={_id}>{_id}</option>
          })}
        </select>
      </div>
      <div>
        <ChamberMap entity={selectedChamberId as Entity} />
      </div>
    </div>
  );
}

export default Minter;
