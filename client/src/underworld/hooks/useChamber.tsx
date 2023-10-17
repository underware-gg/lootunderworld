import { useEffect, useMemo } from "react"
import { Entity, HasValue, Has, getComponentValue } from '@latticexyz/recs'
import { useComponentValue, useEntityQuery } from "@latticexyz/react"
import { useDojoComponents } from '../../DojoContext'
import { bigintToEntity, bigintToHex } from "../utils/utils"
import { Dir, TileType, expandTilemap_1p, offsetCoord } from "../utils/underworld"


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

export const useChamber = (chamberId: bigint) => {
  const { Chamber } = useDojoComponents()

  const chamber: any = useComponentValue(Chamber, bigintToEntity(chamberId))
  const seed = useMemo(() => BigInt(chamber?.seed ?? 0), [chamber])
  const minter = useMemo(() => BigInt(chamber?.minter ?? 0), [chamber])

  return {
    seed,
    minter,
    domain_id: chamber?.domain_id ?? 0,
    token_id: chamber?.token_id ?? 0,
    yonder: chamber?.yonder ?? 0,
  }
}

export const useChamberOffset = (chamberId: bigint, dir: Dir) => {
  const locationId = useMemo(() => offsetCoord(chamberId, dir), [chamberId, dir])
  const result = useChamber(locationId)
  return {
    locationId,
    ...result,
  }
}

export const useChamberMap = (locationId: bigint) => {
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
        const bit = bitmap & (BigInt(1) << BigInt(255-i))
        result.push(bit ? TileType.Path : TileType.Void)
      }
      tiles.forEach((tile) => {
        result[tile.pos] = tile.tile_type
      })
    }
    return result
  }, [bitmap, tiles])
  // useEffect(() => console.log(`tilemap:`, bigintToHex(bitmap), tilemap), [tilemap])

  const expandedTilemap = useMemo(() => expandTilemap_1p(tilemap), [tilemap])

  return {
    bitmap,
    tilemap,
    expandedTilemap,
    doors: {
      north: map?.north ?? 0,
      east: map?.east ?? 0,
      west: map?.west ?? 0,
      south: map?.south ?? 0,
      over: map?.over ?? 0,
      under: map?.under ?? 0,
    }
  }
}

export const useChamberState = (chamberId: bigint) => {
  const { State } = useDojoComponents()
  const state: any = useComponentValue(State, bigintToEntity(chamberId))
  return state ?? {}
}
