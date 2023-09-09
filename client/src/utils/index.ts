import {
    EntityIndex,
} from "@latticexyz/recs";
import { poseidonHashMany } from "micro-starknet";
import { Direction } from "../dojo/createSystemCalls";

export function isValidArray(input: any): input is any[] {
    return Array.isArray(input) && input != null;
}

export function getFirstComponentByType(entities: any[] | null | undefined, typename: string): any | null {
    if (!isValidArray(entities)) return null;

    for (let entity of entities) {
        if (isValidArray(entity?.node.components)) {
            const foundComponent = entity.node.components.find((comp: any) => comp.__typename === typename);
            if (foundComponent) return foundComponent;
        }
    }

    return null;
}

export function extractAndCleanKey(entities?: any[] | null | undefined): string | null {
    if (!isValidArray(entities) || !entities[0]?.keys) return null;

    return entities[0].keys.replace(/,/g, '');
}

export function updatePositionWithDirection(direction: Direction, value: { x: number, y: number }) {
    switch (direction) {
        case Direction.Left:
            value.x--;
            break;
        case Direction.Right:
            value.x++;
            break;
        case Direction.Up:
            value.y--;
            break;
        case Direction.Down:
            value.y++;
            break;
        default:
            throw new Error("Invalid direction provided");
    }
    return value;
}

// DISCUSSION: MUD expects Numbers, but entities in Starknet are BigInts (from poseidon hash)
// so I am converting them to Numbers here, but it means that there is a bigger risk of collisions
export function getEntityIdFromKeys(keys: bigint[]): EntityIndex {
    if (keys.length === 1) {
        return parseInt(keys[0].toString()) as EntityIndex;
    }
    // calculate the poseidon hash of the keys
    let poseidon = poseidonHashMany([BigInt(keys.length), ...keys]);
    return parseInt(poseidon.toString()) as EntityIndex;
}

