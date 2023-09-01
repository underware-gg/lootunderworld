import { SetupNetworkResult } from "./setupNetwork";
import { Account, InvokeTransactionReceiptResponse, shortString } from "starknet";
import { EntityIndex, getComponentValue, setComponent } from "@latticexyz/recs";
import { uuid } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { updatePositionWithDirection } from "../utils";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
    { execute, contractComponents }: SetupNetworkResult,
    { Position, Moves }: ClientComponents
) {

    const spawn = async (signer: Account) => {

        const entityId = parseInt(signer.address) as EntityIndex;

        const positionId = uuid();
        Position.addOverride(positionId, {
            entity: entityId,
            value: { x: 1000, y: 1000 },
        });

        const movesId = uuid();
        Moves.addOverride(movesId, {
            entity: entityId,
            value: { remaining: 100 },
        });

        try {
            const tx = await execute(signer, "spawn", []);

            console.log(tx)
            const receipt = await signer.waitForTransaction(tx.transaction_hash, { retryInterval: 100 })

            const events = parseEvent(receipt)
            const entity = parseInt(events[0].entity.toString()) as EntityIndex

            const movesEvent = events[0] as Moves;
            setComponent(contractComponents.Moves, entity, { remaining: movesEvent.remaining })

            const positionEvent = events[1] as Position;
            setComponent(contractComponents.Position, entity, { x: positionEvent.x, y: positionEvent.y })
        } catch (e) {
            console.log(e)
            Position.removeOverride(positionId);
            Moves.removeOverride(movesId);
        } finally {
            Position.removeOverride(positionId);
            Moves.removeOverride(movesId);
        }
    };

    const move = async (signer: Account, direction: Direction) => {

        const entityId = parseInt(signer.address) as EntityIndex;

        const positionId = uuid();
        Position.addOverride(positionId, {
            entity: entityId,
            value: updatePositionWithDirection(direction, getComponentValue(Position, entityId) as Position),
        });

        const movesId = uuid();
        Moves.addOverride(movesId, {
            entity: entityId,
            value: { remaining: (getComponentValue(Moves, entityId)?.remaining || 0) - 1 },
        });

        try {
            const tx = await execute(signer, "move", [direction]);

            console.log(tx)
            const receipt = await signer.waitForTransaction(tx.transaction_hash, { retryInterval: 100 })

            console.log(receipt)

            const events = parseEvent(receipt)
            const entity = parseInt(events[0].entity.toString()) as EntityIndex

            const movesEvent = events[0] as Moves;
            setComponent(contractComponents.Moves, entity, { remaining: movesEvent.remaining })

            const positionEvent = events[1] as Position;
            setComponent(contractComponents.Position, entity, { x: positionEvent.x, y: positionEvent.y })
        } catch (e) {
            console.log(e)
            Position.removeOverride(positionId);
            Moves.removeOverride(movesId);
        } finally {
            Position.removeOverride(positionId);
            Moves.removeOverride(movesId);
        }

    };

    return {
        spawn,
        move
    };
}


// TODO: Move types and generalise this

export enum Direction {
    Left = 0,
    Right = 1,
    Up = 2,
    Down = 3,
}

export enum ComponentEvents {
    Moves = "Moves",
    Position = "Position",
}

export interface BaseEvent {
    type: ComponentEvents;
    entity: string;
}

export interface Moves extends BaseEvent {
    remaining: number;
}

export interface Position extends BaseEvent {
    x: number;
    y: number;
}

export const parseEvent = (
    receipt: InvokeTransactionReceiptResponse
): Array<Moves | Position> => {
    if (!receipt.events) {
        throw new Error(`No events found`);
    }

    let events: Array<Moves | Position> = [];

    for (let raw of receipt.events) {
        const decodedEventType = shortString.decodeShortString(raw.data[0]);

        switch (decodedEventType) {
            case ComponentEvents.Moves:
                if (raw.data.length < 6) {
                    throw new Error('Insufficient data for Moves event.');
                }

                const movesData: Moves = {
                    type: ComponentEvents.Moves,
                    entity: raw.data[2],
                    remaining: Number(raw.data[5]),
                };

                events.push(movesData);
                break;

            case ComponentEvents.Position:
                if (raw.data.length < 7) {
                    throw new Error('Insufficient data for Position event.');
                }

                const positionData: Position = {
                    type: ComponentEvents.Position,
                    entity: raw.data[2],
                    x: Number(raw.data[5]),
                    y: Number(raw.data[6]),
                };

                events.push(positionData);
                break;

            default:
                throw new Error('Unsupported event type.');
        }
    }

    return events;
};