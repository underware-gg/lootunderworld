import { useMemo, useEffect, useState } from "react"
import { Entity, HasValue, Has, getComponentValue } from '@latticexyz/recs'
import { useComponentValue, useEntityQuery } from "@latticexyz/react"
import { useDojoComponents } from '../../DojoContext'
import { bigintToEntity } from "../utils/utils"
import { TileType } from "../utils/underworld"


//------------------
// All Chambers
//

export const useAllChamberIds = () => {
  const { Chamber } = useDojoComponents()
  const entityIds: Entity[] = useEntityQuery([Has(Chamber)])
  const chamberIds: bigint[] = useMemo(() => (entityIds ?? []).map((entityId) => BigInt(entityId)), [entityIds])
  return {
    chamberIds,
  }
}

export const useRealmChamberIds = (realmId: number) => {
  const { Chamber } = useDojoComponents()
  const entityIds = useEntityQuery([HasValue(Chamber, { token_id: realmId })])
  const chamberIds: bigint[] = useMemo(() => (entityIds ?? []).map((entityId) => BigInt(entityId)), [entityIds])
  return {
    chamberIds,
  }
}


//------------------
// Single Chamber
//

export const useChamber = (locationId: bigint) => {
  const { Chamber } = useDojoComponents()

  const chamber: any = useComponentValue(Chamber, bigintToEntity(locationId))
  const seed = useMemo(() => BigInt(chamber?.seed ?? 0), [chamber])

  const { bitmap, tilemap } = useTilemap(locationId)

  return {
    seed,
    bitmap,
    tilemap,
  }
}

export const useTilemap = (locationId: bigint) => {
  const { Map, Tile } = useDojoComponents()

  const map: any = useComponentValue(Map, bigintToEntity(locationId))
  const bitmap: bigint = useMemo(() => BigInt(map?.bitmap ?? 0), [map])
  // useEffect(() => console.log(`map:`, map, typeof map?.bitmap, bitmap), [bitmap])

  const tileIds: Entity[] = useEntityQuery([HasValue(Tile, { location_id: locationId ?? 0n })])
  // useEffect(() => console.log(`tileIds:`, tileIds), [tileIds])

  const tiles: any[] = useMemo(() => tileIds.map((tileId) => getComponentValue(Tile, tileId)), [tileIds])

  const tilemap = useMemo(() => {
    let result: number[] = []
    if (bitmap && tiles.length > 0) {
      for (let i = 0; i < 256; ++i) {
        const bit = bitmap & (BigInt(1) << BigInt(i))
        result.push(bit ? TileType.Path : TileType.Void)
      }
      tiles.forEach((tile) => {
        result[tile.pos] = tile.tile_type
      })
    }
    return result
  }, [bitmap, tiles])
  // useEffect(() => console.log(`tilemap:`, tilemap), [tilemap])

  return {
    bitmap,
    tilemap,
  }
}

