import { setComponent, Components, Schema } from "@latticexyz/recs";
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
      console.log(`spawn tx:`, tx)
      const receipt = await provider.provider.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      console.log(`spawn receipt:`, receipt)
      const events = getEvents(receipt);
      console.log(`spawn events:`, events)
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
      console.log(`move tx:`, tx)
      const receipt = await signer.waitForTransaction(tx.transaction_hash, { retryInterval: 200 })
      console.log(`move receipt:`, receipt)
      const events = getEvents(receipt);
      console.log(`move events:`, events)
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
  // retrieve the component name
  const componentName = hexToAscii(eventData[0]);

  // retrieve the component from name
  const component = components[componentName];

  // get keys
  const keysNumber = parseInt(eventData[1]);
  let index = 2 + keysNumber + 1;

  const keys = eventData.slice(2, 2 + keysNumber).map((key) => BigInt(key));

  // get entityIndex from keys
  const entityIndex = getEntityIdFromKeys(keys);

  // get values
  let numberOfValues = parseInt(eventData[index++]);

  // get values
  const values = eventData.slice(index, index + numberOfValues);

  // create component object from values with schema
  const componentValues = Object.keys(component.schema).reduce((acc: Schema, key, index) => {
    const value = values[index];
    acc[key] = Number(value);
    return acc;
  }, {});

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
