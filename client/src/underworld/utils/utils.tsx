import { Entity } from '@latticexyz/recs'

export const bigintToHex = (n: bigint) => `0x${n.toString(16)}`
export const bigintToEntity = (n: bigint): Entity => (`0x${n.toString(16)}` as Entity)

