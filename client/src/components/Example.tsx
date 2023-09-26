import './App.css';
import { useEffect } from 'react';
import { useDojo } from '../DojoContext';
import { Entity, setComponent } from '@latticexyz/recs';
import { useComponentValue } from "@latticexyz/react";
import { Direction, } from '../dojo/createSystemCalls'
import { getFirstComponentByType } from '../utils';
import { Moves, Position } from '../generated/graphql';

function Example() {
  const {
    setup: {
      systemCalls: { spawn, move },
      components: { Moves, Position },
      network: { graphSdk, call }
    },
    account: { account }
  } = useDojo();

  // entity id - this example uses the account address as the entity id
  const entityId = BigInt(account.address).toString() as Entity;

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

  return (
    <div className="card">
      <button onClick={() => spawn(account)}>Spawn</button>
      <div>Moves Left: {moves ? `${moves['remaining']}` : 'Need to Spawn'}</div>
      <div>Position: {position ? `${position['x']}, ${position['y']}` : 'Need to Spawn'}</div>
      <button onClick={() => move(account, Direction.Up)}>Move Up</button> <br />
      <button onClick={() => move(account, Direction.Left)}>Move Left</button>
      <button onClick={() => move(account, Direction.Right)}>Move Right</button> <br />
      <button onClick={() => move(account, Direction.Down)}>Move Down</button>
    </div>
  );
}

export default Example;
