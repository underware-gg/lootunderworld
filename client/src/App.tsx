import './App.css';
import { useEffect, useState } from 'react';
import { useDojo } from './DojoContext';
import { Entity, setComponent, HasValue, Has } from '@latticexyz/recs';
import { useComponentValue, useEntityQuery } from "@dojoengine/react";
import { Direction, } from './dojo/createSystemCalls'
import { getFirstComponentByType } from './utils';
import { Moves, Position } from './generated/graphql';
import ChamberMap from './underworld/components/Map';
import { Dir } from './underworld/underworld';

function App() {
  const {
    setup: {
      systemCalls: { spawn, move, mint_realms_chamber },
      components: { Moves, Position, Chamber, Map },
      network: { graphSdk, call }
    },
    account: { create, list, select, account, isDeploying }
  } = useDojo();

  // entity id - this example uses the account address as the entity id
  const entityId = account.address as Entity;

  // get current component values
  const position = useComponentValue(Position, entityId);
  const moves = useComponentValue(Moves, entityId);

  useEffect(() => {

    if (!entityId) return;

    const fetchData = async () => {
      const { data } = await graphSdk.getEntities();

      if (data) {
        let remaining = getFirstComponentByType(data.entities?.edges, 'Moves') as Moves;
        let position = getFirstComponentByType(data.entities?.edges, 'Position') as Position;

        if (remaining) {
          setComponent(Moves, entityId, { remaining: remaining.remaining })
        }
        if (position) {
          setComponent(Position, entityId, { x: position.x, y: position.y })
        }
      }
    }
    fetchData();
  }, [account.address]);


  // const chamberIds = useEntityQuery([HasValue(Chamber, { realm_id: 1 })]);
  const chamberIds = useEntityQuery([Has(Chamber)]);

  const [selectedChamberId, setSelectedChamberId] = useState('0')
  useEffect(() => {
    setSelectedChamberId(chamberIds[chamberIds.length - 1] ?? 0)
  }, [chamberIds])


  return (
    <>
      <button onClick={create}>{isDeploying ? "deploying burner" : "create burner"}</button>
      <div className="card">
        select signer:{" "}
        <select onChange={e => select(e.target.value)}>
          {list().map((account, index) => {
            return <option value={account.address} key={index}>{account.address}</option>
          })}
        </select>
      </div>

      <hr />

      <div className="card">
        <button onClick={() => mint_realms_chamber(account, 1, BigInt(Date.now()%999) | (BigInt(Date.now()%999) << 32n), Dir.Under)}>Mint Chamber</button>
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

      <hr />

      <div className="card">
        <button onClick={() => spawn(account)}>Spawn</button>
        <div>Moves Left: {moves ? `${moves['remaining']}` : 'Need to Spawn'}</div>
        <div>Position: {position ? `${position['x']}, ${position['y']}` : 'Need to Spawn'}</div>
        <button onClick={() => move(account, Direction.Up)}>Move Up</button> <br />
        <button onClick={() => move(account, Direction.Left)}>Move Left</button>
        <button onClick={() => move(account, Direction.Right)}>Move Right</button> <br />
        <button onClick={() => move(account, Direction.Down)}>Move Down</button>
      </div>

    </>
  );
}

export default App;
