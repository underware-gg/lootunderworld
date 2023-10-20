// import { useDojo } from '../DojoContext';
// import { Entity } from '@latticexyz/recs';
// import { useComponentValue } from "@latticexyz/react";
// import { Direction, } from '../dojo/createSystemCalls'

// function Example() {
//   const {
//     setup: {
//       systemCalls: { spawn, move },
//       components: { Moves, Position },
//       // network: { graphSdk }
//     },
//     account: { account }
//   } = useDojo();

//   // entity id - this example uses the account address as the entity id
//   const entityId = ('0x' + BigInt(account.address).toString(16)) as Entity;

//   // get current component values
//   const position = useComponentValue(Position, entityId);
//   const moves = useComponentValue(Moves, entityId);

//   return (
//     <div className="card">
//       <button onClick={() => spawn(account)}>Spawn</button>
//       <div>Moves Left: {moves ? `${moves['remaining']}` : 'Need to Spawn'}</div>
//       <div>Position: {position ? `${position['x']}, ${position['y']}` : 'Need to Spawn'}</div>
//       <button onClick={() => move(account, Direction.Up)}>Move Up</button> <br />
//       <button onClick={() => move(account, Direction.Left)}>Move Left</button>
//       <button onClick={() => move(account, Direction.Right)}>Move Right</button> <br />
//       <button onClick={() => move(account, Direction.Down)}>Move Down</button>
//     </div>
//   );
// }

// export default Example;
