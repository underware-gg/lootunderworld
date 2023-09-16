import {
  Schema,
  Components,
  setComponent,
  Type as RecsType,
} from "@latticexyz/recs";
import { Account } from "starknet";
import { SetupNetworkResult } from "./setupNetwork";
import { getEntityIdFromKeys } from "../utils";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export enum Direction {
  Left = 0,
  Right = 1,
  Up = 2,
  Down = 3,
}

export function createSystemCalls(
  { execute, provider, contractComponents }: SetupNetworkResult,
  // { Position, Moves, Chamber, Map }: ClientComponents,
) {


  const generate_chamber = async (signer: Account, realmId: number, location: number) => {
    try {
      const tx = await execute(signer, "generate_chamber", [realmId, location]);
      console.log(`generate_chamber tx:`, tx)
      const receipt = await provider.provider.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      console.log(`generate_chamber receipt:`, receipt)

      // console.log(`generate_chamber contract:`, provider.contract)
      // console.log(`generate_chamber contract.parseEvents():`, provider.contract.parseEvents(receipt))

      const events = getEvents(receipt);
      console.log(`generate_chamber events:`, events)
      setComponentsFromEvents(contractComponents, events);

    } catch (e) {
      console.log(`generate_chamber exception:`, e)
    } finally {
    }
  };



  //------------------------
  // EXAMPLE
  //
  const spawn = async (signer: Account): Promise<number> => {
    let entity_id: number = 0;

    // const entityId = parseInt(signer.address) as EntityIndex;
    // const positionId = uuid();
    // Position.addOverride(positionId, {
    //     entity: entityId,
    //     value: { x: 1000, y: 1000 },
    // });
    // const movesId = uuid();
    // Moves.addOverride(movesId, {
    //     entity: entityId,
    //     value: { remaining: 100 },
    // });

    try {
      const tx = await execute(signer, "spawn", []);
      const receipt = await provider.provider.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      const events = getEvents(receipt);
      setComponentsFromEvents(contractComponents, events);
      entity_id = getEntityIdFromEvents(events, "Moves");
    } catch (e) {
      console.log(`spawn exception:`, e)
      // Position.removeOverride(positionId);
      // Moves.removeOverride(movesId);
    } finally {
      // Position.removeOverride(positionId);
      // Moves.removeOverride(movesId);
    }
    return entity_id;
  };

  const move = async (signer: Account, direction: Direction): Promise<number> => {
    let entity_id: number = 0;

    // const entityId = parseInt(signer.address) as EntityIndex;
    // const positionId = uuid();
    // Position.addOverride(positionId, {
    //     entity: entityId,
    //     //@ts-ignore
    //     value: updatePositionWithDirection(direction, getComponentValue(Position, entityId) as Position),
    // });
    // const movesId = uuid();
    // Moves.addOverride(movesId, {
    //     entity: entityId,
    //     value: { remaining: (getComponentValue(Moves, entityId)?.remaining || 0) - 1 },
    // });

    try {
      const tx = await execute(signer, "move", [direction]);
      const receipt = await signer.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      const events = getEvents(receipt);
      setComponentsFromEvents(contractComponents, events);
      entity_id = getEntityIdFromEvents(events, "Moves");
    } catch (e) {
      console.log(`move exception:`, e)
      // Position.removeOverride(positionId);
      // Moves.removeOverride(movesId);
    } finally {
      // Position.removeOverride(positionId);
      // Moves.removeOverride(movesId);
    }
    return entity_id;
  };

  return {
    generate_chamber,
    spawn,
    move
  };
}


export function getEvents(receipt: any): any[] {
  return receipt.events.filter((event: any) => {
    return event.keys.length === 1 && event.keys[0] === import.meta.env.VITE_EVENT_KEY;
  });
}

export function setComponentsFromEvents(components: Components, events: Event[]) {
  //@ts-ignore
  events.forEach((event) => setComponentFromEvent(components, event.data));
}

export function setComponentFromEvent(components: Components, eventData: string[]) {
  // retrieve the component
  const componentName = hexToAscii(eventData[0]);
  const component = components[componentName];

  // get keys
  const keysCount = parseInt(eventData[1]);
  const keys = eventData.slice(2, 2 + keysCount).map((key) => BigInt(key));
  const entityIndex = getEntityIdFromKeys(keys);
  // console.log(`EVENT [${componentName}] keys [${keysCount}]`, keys, entityIndex)

  // shift to values
  let dataIndex =
    1 +   // component name
    1 +   // keys count
    keysCount + // keys
    + 1   // 0x0
    + 1;  // values count

  // const valuesCount = parseInt(eventData[dataIndex]);
  // console.log(`EVENT [${componentName}] values [${valuesCount}]`, eventData.slice(dataIndex))
  // console.log(`EVENT schema`, component)

  // create component object from values with schema
  const componentValues = Object.keys(component.schema).reduce((acc: Schema, key, index) => {
    let value: any;
    if (component.schema[key] == RecsType.Boolean) {
      value = Number(eventData[dataIndex++]) != 0;
    } else if (component.schema[key] == RecsType.Number) {
      value = Number(eventData[dataIndex++]);
    } else if (component.schema[key] == RecsType.BigInt) {
      //@ts-ignore
      if (component.metadata?.types?.[index] == 'u256') {
        value = BigInt(eventData[dataIndex++]) + (BigInt(eventData[dataIndex++]) << 128n);
      } else {
        value = BigInt(eventData[dataIndex++]);
      }
    } else { // String
      value = eventData[dataIndex++];
    }
    // console.log(`--value @${dataIndex}:`, key, value.toString(16))
    acc[key] = value;
    return acc;
  }, {});
  console.log(`VALUES:`, componentValues)

  // set component
  setComponent(component, entityIndex, componentValues);
}

function hexToAscii(hex: string) {
  var str = "";
  for (var n = 2; n < hex.length; n += 2) {
    str += String.fromCharCode(parseInt(hex.substr(n, 2), 16));
  }
  return str;
}

function asciiToHex(ascii: string) {
  var hex = "";
  for (var i = 0; i < ascii.length; i++) {
    var charCode = ascii.charCodeAt(i);
    hex += charCode.toString(16).padStart(2, "0");
  }
  return `0x${hex}`;
}

function getEntityIdFromEvents(events: Event[], componentName: string): number {
  let entityId = 0;
  const event = events.find((event) => {
    //@ts-ignore
    return event.data[0] === asciiToHex(componentName);
  });
  if (event) {
    //@ts-ignore
    entityId = parseInt(event.data[2]);
  }
  return entityId;
}


// Event keys (event hash)
// 0x1a2f334228cee715f1f0f54053bb6b5eac54fa336e0bc1aacf7516decb0471d

// Chamber
// data: Array(10)
// 0: "0x4368616d626572"    name
// 1: "0x1"                 keys_count
// 2: "0x9"                 key : entity_id
// 3: "0x0"                 ?
// 4: "0x5"                 data_count
// 5: "0x1"                 data: realm_id
// 6: "0x18a9b743912"       data: location
// 7: "0x8bee3eaa82565df3aa3490f3cc638b8d"    data: seed.low
// 8: "0x67005de7ad14a037d950d0894998d9a6"    data: seed.high
// 9: "0x517ececd29116499f4a1b64b094da79ba08dfd54a3edaa316134c41f8160973"   minter

// Map
// data:Array(7)
// 0:"0x4d6170"
// 1:"0x1"
// 2:"0x9"
// 3:"0x0"    ??
// 4:"0x2"
// 5:"0xffff3fbf935f5dfffe3ffcffcdff8bed"
// 6:"0x6700dff7ef1fef3fdffafff97ff8fffe"

// Door
// data:Array(8)
// 0:"0x446f6f72"
// 1:"0x2"
// 2:"0x9"
// 3:"0x1"
// 4:"0x0"    ??
// 5:"0x2"
// 6:"0x8f"
// 7:"0x18a9b743912"

